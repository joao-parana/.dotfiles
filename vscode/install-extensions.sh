#!/bin/bash

code --install-extension "$(cat code-extensions.list | tr "\n" " ")"
