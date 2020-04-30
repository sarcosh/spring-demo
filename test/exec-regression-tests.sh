#!/bin/bash

cd /home/sarcosh/test/source

export DISPLAY=':0'

mvn clean install -Dtest=Regression*