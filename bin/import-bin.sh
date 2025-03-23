#!/bin/bash

local="$(pwd)"
chmod +x "$local"/*
sudo cp -av "$local"/* /usr/local/bin
