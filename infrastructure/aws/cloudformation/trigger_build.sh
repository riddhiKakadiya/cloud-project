#!/bin/bash

echo "Input Circle CI Token: "
read TOKEN

echo "Input Circle CI URL: "
read URL

curl -u $TOKEN -d build_parameters[CIRCLE_JOB]=build $URL