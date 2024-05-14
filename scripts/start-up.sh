#!/bin/bash

# Run Jupyter lab and allow for RunAI added parameters
exec jupyter lab --port=8888 --ip=0.0.0.0 --allow-root $1 $2 $3

