#!/bin/bash

# shellcheck disable=SC2010
for i in $(ls /sys/class/leds | grep scrolllock); do
#echo 1 | sudo tee /sys/class/leds/$i/brightness
brightnessctl --device="$i" set 1
done
