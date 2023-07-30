#!/bin/bash
sudo sed 's/#greeter-session=lightdm-slick-greeter/greeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf > /etc/lightdm/lightdm1.conf
sudo rm -Rf /etc/lightdm/lightdm.conf
sudo mv /etc/lightdm/lightdm1.conf /etc/lightdm/lightdm.conf

