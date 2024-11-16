#!/bin/sh
sudo apt update
sudo apt install docker-compose -y
sudo apt install git
git clone https://github.com/SVA999/final-telematica
cd final-telematica
sudo docker-compose up -d
