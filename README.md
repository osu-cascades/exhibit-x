# Exhibit X

A collection of configuration files, scripts, documentation and Processing
programs for an interactive computational art exhibit, to help market the
creativity behind code.

## Repository Directories

| Directory            | Description                                                                                  |
|----------------------|----------------------------------------------------------------------------------------------|
| emptyExample         | Obsolete demo program (PENDING REMOVAL)                                                      |
| exhibit_supervisor   | The main supervisor program that runs the exhibit computer                                   |
| kinectExample        | Obsolete demo program (PENDING REMOVAL)                                                      |
| micTest              | Obsolete demo program (PENDING REMOVAL)                                                      |
| microphone/rects_mic | Microphone demo processing sketch                                                            |
| nonKinect            | Directory containing multiple processing sketches that  don't rely upon the kinect           |
| ofBubbleBenchmark    | Obsolete demo program (PENDING REMOVAL)                                                      |
| onExhibit            | Directory containing multiple processing sketches that are currently deployed on the exhibit |
| pong                 | Obsolete demo program (PENDING REMOVAL)                                                      |
| runner               | Obsolete sketch supervisor used during an early deployment                                   |
| worksInProgress      | Directory containing multiple processing sketches that are not ready for deployment          |

## Exhibit Supervisor

### TL;DR

#### What?
The exhibit supervisor ensures the exhibit projector is always displaying the sketch(es) requested by the web interface administrators

#### How?
The supervisor continuously runs in the backround, executing a loop about once a second.

During each loop, the supervisor checks a few status items

* What does the server want me to do?
* What sketch should I be running?
* Is that sketch running right now?
  * If not, download and run it

#### Where?
Under the main stairwell in Tykeson

(c) 2022 Yong Joseph Bakos, Brad Cook, Colin Suckow, Max Mitchell All rights reserved.
