#!/bin/bash

sudo apt install git
git config --global user.name "boms606" 
mkdir scripts
cd scripts
mkdir bomsgit
git clone git://github.com/boms606/first_one.git
cd first_one
sudo chmod +x first_setup.sh
./first_setup.sh

