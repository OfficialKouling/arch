#!/bin/bash
exec mkfs.fat -F 32 /dev/sda1
exec mkfs.ext4 /dev/sda2
exec mkfs.ext4 /dev/sda3
