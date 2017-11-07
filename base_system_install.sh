#!/bin/bash
# Author: Alvinho - P&D - DTPD

# Ubuntu 16.04 x86-64 - Xenial Xerus - minimum RAM 4GB

# Update OS
sudo apt -y update
sudo apt -y upgrade

# Install Base image pre-requisites
sudo apt install -y libprotobuf-dev libleveldb-dev libsnappy-dev \
libopencv-dev libhdf5-serial-dev protobuf-compiler libopenblas-dev \
libgflags-dev libgoogle-glog-dev liblmdb-dev python-dev \
software-properties-common git gfortran python-numpy vim \
python-scipy cmake libtbb-dev libfreetype6-dev feh \
apt-transport-https ca-certificates curl

# Install NVIDIA driver + CUDA9 + CUDNN7 runtime + samples
echo "blacklist amd76x_edac" | sudo tee --append /etc/modprobe.d/blacklist.conf
echo "blacklist vga16fb" | sudo tee --append /etc/modprobe.d/blacklist.conf
echo "blacklist nouveau" | sudo tee --append /etc/modprobe.d/blacklist.conf
echo "blacklist rivafb" | sudo tee --append /etc/modprobe.d/blacklist.conf
echo "blacklist nvidiafb" | sudo tee --append /etc/modprobe.d/blacklist.conf
echo "blacklist rivatv" | sudo tee --append /etc/modprobe.d/blacklist.conf
cd "${HOME}"
sudo apt-get -y --purge remove nvidia-*
wget -c http://us.download.nvidia.com/XFree86/Linux-x86_64/384.90/NVIDIA-Linux-x86_64-384.90.run
chmod +x NVIDIA-Linux-x86_64-384.90.run
sudo sh NVIDIA-Linux-x86_64-384.90.run --silent --accept-license
rm NVIDIA-Linux-x86_64-384.90.run
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
wget -c http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
rm cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt update
sudo apt install -y cuda-toolkit-9-0
sudo /usr/local/cuda-9.0/bin/cuda-install-samples-9.0.sh ~
wget -c https://www.dropbox.com/s/kjizn0ozis4w46e/libcudnn7_7.0.3.11-1%2Bcuda9.0_amd64.deb
sudo dpkg -i libcudnn7_7.0.3.11-1+cuda9.0_amd64.deb
sudo apt-get -f -y install
rm libcudnn7_7.0.3.11-1+cuda9.0_amd64.deb
echo "PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}" >> ~/.profile
echo "LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.profile
source ~/.profile


# Install NVIDIA docker
# Install docker Community Edition
cd ~
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt -y update
sudo apt install -y docker-ce
sudo apt install -y nvidia-modprobe
wget -c https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
sudo dpkg -i nvidia-docker_1.0.1-1_amd64.deb
rm nvidia-docker_1.0.1-1_amd64.deb
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi

sudo apt-get -y autoremove
