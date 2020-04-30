#!/bin/bash

cd /home/sarcosh/test/spring-demo

export DISPLAY=':0'

mvn clean install -Dtest=Regression*