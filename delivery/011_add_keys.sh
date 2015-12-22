#!/bin/bash

# add fabscan.org archive key to apt
wget http://archive.fabscan.org/fabscan.public.key -O - | apt-key add -
