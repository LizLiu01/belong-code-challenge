#!/bin/bash

PROJECT_HOME="/Users/liz/Projects/belong-code-challenge"
VENV_HOME="/Users/liz/python-envs/py3.7-dlib"

cd $VENV_HOME
source bin/activate
cd $PROJECT_HOME
python setup.py bdist_wheel
