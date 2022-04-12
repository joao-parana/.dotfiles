#!/bin/bash

docker stop $(docker ps -q)
sudo shutdown -h now
