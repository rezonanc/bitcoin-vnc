#!/bin/bash

# Remove VNC lock (if process already killed)
rm /tmp/.X1-lock /tmp/.X11-unix/X1

# Apply password
[ ! -e /password.txt ] && echo "Password not supplied! Attach a volume at /password.txt." && exit 1
cat /password.txt /password.txt | vncpasswd

# Run VNC server with tail in the foreground
vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log
