#!/bin/sh
sudo apt update
sudo apt install docker-compose -y
sudo apt install git
git clone https://github.com/SVA999/FinalTelematica
cd FinalTelematica
sudo docker-compose up -d
