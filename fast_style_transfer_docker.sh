#!/bin/bash
# Author: Alvinho - P&D - DTPD

# Ubuntu 16.04 x86-64 - Xenial Xerus - minimum RAM 4GB

# Create project directory
mkdir -p "$HOME"/transferstyle
cd "$HOME"/transferstyle
# Create DockerFile
# ........

# "compile" docker images
sudo docker build -t transferstyle .

mkdir -p "$HOME"/images_input
cd "$HOME"/images_input
# Grab some test images, keep the largest ones
wget -nd -H -p -A jpg -e robots=off epicantus.tumblr.com/page/{1..1}
rm *500.jpg
mkdir -p "$HOME"/images_output

# Run docker with GPU support, removing old instances and mapping ~/images_input to /input inside container as read-only
# map ~/images_output to /output inside container
# This container stylizes images on ~/images_input to ~/images_output and gracefully exits
cd "$HOME"/transferstyle
sudo nvidia-docker run --rm -v "$HOME"/images_input:/input:ro -v "$HOME"/images_output:/output -it transferstyle
