from __future__ import annotations # Enables some experimental type hinting features so download() can return a Sketch object
import os
from typing import Optional, Dict, Protocol
import requests
import uuid
import urllib.request
import zipfile
import tempfile
import subprocess
import pickle
import psutil
from datetime import datetime
import time
from projector import Projector
from datetime import datetime, time

API_URL = "https://exhibitx.herokuapp.com"
API_CURRENT_SKETCH = "/exhibit/current"
API_HEARTBEAT = "/exhibit/heartbeat"
SKETCHES_DIR = os.path.dirname(os.path.realpath(__file__)) + "/sketches"
SUPERVISOR_PICKLE_FILE = os.path.dirname(os.path.realpath(__file__)) + "/supervisor_state.p"
ACTIVE_START_TIME = time(7) # 7am
ACTIVE_END_TIME = time(18) # 6pm

class Sketch:
    def __init__(self, id: int, path: str) -> None:
        self.id = id
        self.path = path

    @staticmethod
    def download(id: int, filename: str, url: str) -> Sketch:
        unique_name = str(uuid.uuid4())
        sketch_dir = SKETCHES_DIR + "/{}/{}".format(unique_name, filename)
        print("Attempting to download new sketch from {} to {}".format(url, tempfile.gettempdir()))
 
        # TODO: Handle an invalid response code
        (zip_path, _code) =  urllib.request.urlretrieve(url)

        os.makedirs(sketch_dir) # If theres a uuid collision this will break. I can live with the chances of that happening for now

        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(SKETCHES_DIR + "/{}".format(unique_name))

        return Sketch(id, sketch_dir)

class Runner(Protocol):
    def desiredSketch(self) -> Sketch: ...
    def id(self) -> int: ...
    def type(self) -> str: ...
    def details(self) -> str: ...

class SingleSketchRunner:
    def __init__(self, id: int, sketch: Sketch):
        self.sketch = sketch
        self.display_id = id

    def desiredSketch(self) -> Sketch:
        return self.sketch

    def id(self) -> int:
        return self.display_id
    
    def type(self) -> str:
        return "singleSketch"

    def details(self) -> str:
        return "type:{},id:{}".format(self.id(), self.type())

class StaticRotationRunner:
    def __init__(self, id: int, sketch_list: list[Sketch], periodSeconds: int):
        self.sketch_list = sketch_list
        self.current_sketch_index = 0
        self.last_change = datetime.now()
        self.periodSeconds = periodSeconds
        self.display_id = id

    def desiredSketch(self) -> Sketch:
        if (datetime.now() - self.last_change).total_seconds() > self.periodSeconds:
            self.current_sketch_index = (self.current_sketch_index + 1) % len(self.sketch_list)
            self.last_change = datetime.now()
        return self.sketch_list[self.current_sketch_index]

    def id(self) -> int:
        return self.display_id

    def type(self) -> str:
        return "staticRotation"

    def details(self) -> str:
        return "type:{},id:{},period:{},sketches:{}".format(self.id(), self.type(), self.periodSeconds, self.sketch_list)


class Supervisor:
    def __init__(self) -> None:
        self.current_runner: Optional[Runner] = None
        self.sketch_cache: Dict[int, Sketch] = {}
        self.current_sketch_id: Optional[int] = None
        self.projector = Projector()
    
    def sketch_already_running(self) -> bool:
        alive = False
        for p in psutil.process_iter():
            if p.name() == "processing-java" and (p.status() == "sleeping" or p.status() == "running"):
                alive = True
        return alive

    def start_sketch(self, sketch: Sketch) -> None:
        # Kill existing sketches before starting a new one
        subprocess.run(["killall", "/home/exhibitx/.local/share/applications/processing-3.5.4/java/bin/java"])
        subprocess.Popen(["/home/exhibitx/.local/share/applications/processing-3.5.4/processing-java", "--sketch={}".format(sketch.path), "--present"])

    def try_fetch_desired_runner(self) -> Optional[Runner]:
        response = requests.get(API_URL + API_CURRENT_SKETCH)
        
        if response.status_code != 200:
            print("Got bad response code {} while trying to poll {} in try_fetch_desired_runner()".format(response.status_code, API_URL + API_CURRENT_SKETCH))
            return None

        try:
            re_json = response.json()
        except Exception as e:
            print("Unable to parse response json in try_fetch_desired_runner(). Received error: {}".format(e))
            return None

        try:
            if re_json['type'] == "singleSketch":
                sketch_id = re_json['payload']['sketchID']
                sketch_name = re_json['payload']['title']
                sketch_url = re_json['payload']['downloadURL']
                sketch = self.acquire_sketch(sketch_id, sketch_name, sketch_url)
                if sketch is None:
                    print("Unable to acquire sketch used in new singleSketch. id: {} url: {}".format(sketch_id, sketch_url))
                    return None
                return SingleSketchRunner(int(sketch_id), sketch)

            if re_json['type'] == "staticRotation":
                sketches_json = re_json['payload']['sketches']
                sketches: list[Sketch] = []
                for sketch_json in sketches_json:
                    sketch_id = sketch_json['SketchID']
                    sketch_name = sketch_json['title']
                    sketch_url = sketch_json['downloadURL']
                    sketch = self.acquire_sketch(sketch_id, sketch_name, sketch_url)
                    if sketch is None:
                        print("Unable to acquire sketch used in new sketchRotation. id: {} url: {}".format(sketch_id, sketch_url))
                        return None
                    sketches.append(sketch)
                return StaticRotationRunner(int(re_json['payload']['id']), sketches, int(re_json['payload']['periodSeconds']))
                

        except Exception as e:
            print("Failed to pull information from json in try_fetch_desired_runner(). Received error: {}".format(e))
            return None

    def save_state(self) -> None:
        pickle.dump(self, open(SUPERVISOR_PICKLE_FILE, "wb"))

    ### Grab sketch from cache or download if unavilable
    def acquire_sketch(self, sketch_id: int, name: str, url: str) -> Optional[Sketch]:
        if sketch_id in self.sketch_cache:
            return self.sketch_cache[sketch_id]
        else:
            sketch = Sketch.download(sketch_id, name, url)
            self.sketch_cache[sketch_id] = sketch
            return sketch

    def run(self):
        # Create the sketch download directory if it doesn't exist
        if not os.path.isdir( SKETCHES_DIR):
            os.mkdir(SKETCHES_DIR)

        new_runner = self.try_fetch_desired_runner()

        # If this is a new runner, set it to be the current runner
        if new_runner is not None and (self.current_runner is None or self.current_runner.details() != new_runner.details()):
            self.current_runner = new_runner

        if self.current_runner is not None:
            runner_requested_sketch = self.current_runner.desiredSketch()

            if runner_requested_sketch.id != self.current_sketch_id or not self.sketch_already_running():
                self.start_sketch(runner_requested_sketch)
                self.current_sketch_id = runner_requested_sketch.id

        try:
            current_id =  self.current_runner.id() if self.current_runner is not None else -1
            current_type = self.current_runner.type() if self.current_runner is not None else "N/A" 
            requests.post(API_URL + API_HEARTBEAT, data={"activeDisplayId": current_id, "activeDisplayType": current_type})
        except Exception as e:
            print("Failed to send heartbeat message. Received the following error...")
            print(e)

        self.update_projector()

        self.save_state()

    def update_projector(self):
        current_time = datetime.now().time()
        is_active_hours = current_time > ACTIVE_START_TIME and current_time < ACTIVE_END_TIME
        if is_active_hours and self.projector.is_off():
            self.projector.on()
        
        if not is_active_hours and self.projector.is_on():
            self.projector.off()

def main():
    try:
        # Try to load supervisor state from disk
        sup = pickle.load(open(SUPERVISOR_PICKLE_FILE, "rb"))
    except Exception:
        # Start fresh if something goes wrong
        sup = Supervisor()
    print("loaded")
    while True:
        sup.run()
        time.sleep(1)


if __name__ == "__main__":
    main()
