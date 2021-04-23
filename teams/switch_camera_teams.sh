#!/bin/bash

ACTIVE_WINDOW=$(xdotool getactivewindow)
TEAMS_WINDOW=$(xdotool search --onlyvisible --limit 1 --class "Teams")

xdotool windowactivate $TEAMS_WINDOW
xdotool key ctrl+shift+o
xdotool windowactivate $ACTIVE_WINDOW
