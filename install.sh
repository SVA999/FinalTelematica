#!/bin/sh
sudo apt update
sudo apt install docker-compose -y
sudo apt install git
git clone https://github.com/SVA999/FinalTelematica.git
cd ProyectTelematica
docker-compose up -d