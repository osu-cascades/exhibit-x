from __future__ import annotations # Enables some experimental type hinting features so download() can return a Sketch object
import os
from typing import Optional, Dict
import requests
import uuid
import urllib.request
import zipfile
import tempfile
import subprocess
import pickle
import psutil

# crontab expression to use with this script
# * * * * * DISPLAY=:0 /usr/bin/python3 /home/exhibitx/ExhibitX/exhibit-x/exhibit_supervisor/supervisor.py

API_URL = "https://exhibitx.herokuapp.com"
API_CURRENT_SKETCH = "/sketch/current"
SKETCHES_DIR = os.path.dirname(os.path.realpath(__file__)) + "/sketches"
SUPERVISOR_PICKLE_FILE = os.path.dirname(os.path.realpath(__file__)) + "/supervisor_state.p"

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

class Supervisor:
    def __init__(self) -> None:
        self.current_sketch: Optional[Sketch] = None
        self.sketch_cache: Dict[int, Sketch] = {}
    
    # TODO: Refactor
    def try_fetch_latest_sketch(self) -> Optional[Sketch]:
        try:
            response = requests.get(API_URL + API_CURRENT_SKETCH)
        except Exception:
            print("Failed to get response from server. Am I connected to the internet?")
            return None
        if response.status_code != 200:
            print("Got bad response code {} while trying to poll {} in try_fetch_latest_sketch()".format(response.status_code, API_URL + API_CURRENT_SKETCH))
            return None

        try:
            response_json = response.json()
        except Exception as e:
            print("Unable to parse response json in try_fetch_latest_sketch(). Received error: {}".format(e))
            return None

        try:
            latest_id = int(response_json['sketchID'])
            download_url = response_json["downloadURL"]
            title = response_json["title"]
        except Exception as e:
            print("Failed to grab sketch attributes from json map {} with error {}".format(response_json, e))
            return None

        if self.current_sketch is not None and self.current_sketch.id == latest_id:
            # The latest sketch hasn't changed since we last looked, so return nothing
            return None

        # Grab the sketch from cache if we have already downloaded it
        if latest_id in self.sketch_cache:
            return self.sketch_cache[latest_id]

        new_sketch = Sketch.download(latest_id, title, download_url)
        self.sketch_cache[latest_id] = new_sketch # Add the new sketch to the sketch cache
        return new_sketch

    def sketch_already_running(self) -> bool:
        return "processing-java" in (p.name() for p in psutil.process_iter())

    def start_sketch(self, sketch: Sketch) -> None:
        # Kill existing sketches before starting a new one
        subprocess.run(["killall", "/home/exhibitx/.local/share/applications/processing-3.5.4/java/bin/java"])
        subprocess.Popen(["/home/exhibitx/.local/share/applications/processing-3.5.4/processing-java", "--sketch={}".format(sketch.path), "--present"])

    def save_state(self) -> None:
        pickle.dump(self, open(SUPERVISOR_PICKLE_FILE, "wb"))

    def run(self):
        # Create the sketch download directory if it doesn't exist
        if not os.path.isdir( SKETCHES_DIR):
            os.mkdir(SKETCHES_DIR)

        new_sketch = self.try_fetch_latest_sketch()

        if new_sketch is not None:                                                   # If there is a new sketch, start it
            self.start_sketch(new_sketch)
            self.current_sketch = new_sketch
        elif not self.sketch_already_running() and self.current_sketch is not None:  # If not, make sure the current sketch is still running
            self.start_sketch(self.current_sketch)

        self.save_state()

def main():
    try:
        # Try to load supervisor state from disk
        sup = pickle.load(open(SUPERVISOR_PICKLE_FILE, "rb"))
    except Exception:
        # Start fresh if something goes wrong
        sup = Supervisor()

    sup.run()

if __name__ == "__main__":
    main()
