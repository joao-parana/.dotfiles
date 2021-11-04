#!/bin/bash

sudo pacman -Syu --needed - < pkg.list

paru -Syu --needed - < aur.list
