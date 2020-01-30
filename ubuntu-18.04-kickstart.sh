#!/usr/bin/env bash

set -e

echo "---------------------Check OS  and version---------------------"
os_version=$(lsb_release -a | grep Description | awk '{ print $2}')
if [[ $os_version -ne 'Ubuntu' ]]
then
  echo "---------------------This script is for Ubuntu only---------------------"
  exit 1
fi
echo "---------------------Os OK. Cheking version---------------------"
os_number=$(lsb_release -a | grep Release | awk '{ print $2}')
if [[ $os_number != 18.04 ]]
then
  echo "---------------------Your ubuntu version is not 18.04---------------------"
  echo "---------------------That may corrupt your environment setup---------------------"
fi

echo "---------------------Remove current box---------------------"
vbox=$(vagrant box list | grep 'centos/7' | wc -l)
if [[ $vbox -ne 0 ]]
then
  vagrant box remove centos/7
fi

echo "---------------------Remove current vagrant---------------------"
apt purge -y vagrant
apt autoremove -y
apt update -y

echo "---------------------Remove current ansible---------------------"
apt purge -y ansible
apt autoremove -y
apt update -y

echo "---------------------Install Vagrant---------------------"
wget -c https://releases.hashicorp.com/vagrant/2.0.3/vagrant_2.0.3_x86_64.deb
sudo dpkg -i vagrant_2.0.3_x86_64.deb

echo "---------------------Install vagrant-vbox plugin---------------------"
vagrant plugin install vagrant-vbguest

echo "---------------------Install latest virtualbox---------------------"
apt install -y virtualbox-qt virtualbox-guest-utils
apt update

# LatestVirtualBoxVersion=$(wget -qO - http://download.virtualbox.org/virtualbox/LATEST.TXT)
wget "http://download.virtualbox.org/virtualbox/5.2.18/Oracle_VM_VirtualBox_Extension_Pack-5.2.18.vbox-extpack"

VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-5.2.18.vbox-extpack

echo "---------------------Install ansible---------------------"
apt update
apt install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
pip3 install ansible==2.6.4 && pip3 install netaddr==0.7.19

echo "---------------------Remove downloaded archives---------------------"
vbox=$(ls | grep Oracle_VM_VirtualBox | wc -l)

if [[ $vbox -ne 0 ]]
then
  rm Oracle_VM_VirtualBox_*
fi

vbox=$(ls | grep vagrant_ | wc -l)
if [[ $vbox -ne 0 ]]
then
  rm vagrant_*
fi

echo "---------------------Done---------------------"

echo "Now you can start vagrant by typing 'vagrant up'"