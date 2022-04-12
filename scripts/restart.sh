#!/bin/bash

docker stop $(docker ps -q)
sudo reboot
