
from __future__ import annotations # Enables some experimental type hinting features so download() can return a Sketch object
import os
from typing import Optional, Dict
import requests
import uuid
import urllib.request
import zipfile
import tempfile
import subprocess

API_URL = "https://exhibitx.herokuapp.com"
API_CURRENT_SKETCH = "/sketch/current"
SKETCHES_DIR = os.path.dirname(os.path.realpath(__file__)) + "/sketches"

class Sketch:
    def __init__(self, id: int, path: str) -> None:
        self.id = id
        self.path = path

    @staticmethod
    def download(id: int, url: str) -> Sketch:
        working_name = str(uuid.uuid4())
        sketch_dir = SKETCHES_DIR + "/" + working_name
        print("Attempting to download new sketch from {} to {}".format(url, tempfile.gettempdir()))
        download_path = tempfile.gettempdir() + "/" + "{}.zip".format(working_name)
        urllib.request.urlretrieve("https://" + url, download_path)
        os.mkdir(sketch_dir) # If theres a uuid collision this will break. I can live with the chances of that happening for now

        with zipfile.ZipFile(download_path, 'r') as zip_ref:
            zip_ref.extractall(sketch_dir)

        return Sketch(id, sketch_dir)

class Supervisor:
    def __init__(self) -> None:
        self.current_sketch: Optional[Sketch] = None
        self.sketch_cache: Dict[int, Sketch] = {}
    
    # TODO: Refactor
    def try_fetch_latest_sketch(self) -> Optional[Sketch]:
        response = requests.get(API_URL + API_CURRENT_SKETCH)
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
        except Exception as e:
            print("Failed to grab sketch attributes from json map {} with error {}".format(response_json, e))
            return None

        if self.current_sketch is not None and self.current_sketch.id == latest_id:
            # The latest sketch hasn't changed since we last looked, so return nothing
            return None

        # Grab the sketch from cache if we have already downloaded it
        if latest_id in self.sketch_cache:
            return self.sketch_cache[latest_id]

        new_sketch = Sketch.download(latest_id, download_url)
        self.sketch_cache[latest_id] = new_sketch # Add the new sketch to the sketch cache
        return new_sketch


    def start_sketch(self, sketch: Sketch) -> None:
        subprocess.run(["processing-java", "--sketch={}".format(sketch.path), "--run"])

    def save_state(self) -> None:
        pass

    def run(self):
        # Create the sketch download directory if it doesn't exist
        if not os.path.isdir( SKETCHES_DIR):
            os.mkdir(SKETCHES_DIR)

        new_sketch = self.try_fetch_latest_sketch()

        if new_sketch is not None:
            self.start_sketch(new_sketch)
            self.current_sketch = new_sketch

        #self.save_state()


sup = Supervisor()
sup.run()
