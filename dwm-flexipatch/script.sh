#!/bin/bash
username=$(ls /home | awk '/^[^lost+found]/ { print $1 }')
old_norm_fg=$(cat /home/${username}/dwm-flexipatch/config.h | grep -m1 "normfgcolor\[\]" | awk '{print $5}')
old_norm_bg=$(cat /home/${username}/dwm-flexipatch/config.h | grep -m1 "normbgcolor\[\]" | awk '{print $5}')
old_norm_border=$(cat /home/${username}/dwm-flexipatch/config.h | grep -m1 "normbordercolor\[\]" | awk '{print $5}')
old_sel_bg=$(cat /home/${username}/dwm-flexipatch/config.h | grep -m1 "selfgcolor\[\]" | awk '{print $5}')
old_urg_bg=$(cat /home/${username}/dwm-flexipatch/config.h | grep -m1 "urgbgcolor\[\]" | awk '{print $5}')

sudo rm -rf /home/${username}/.cache/wal
sudo cp ${1} /home/${username}/wallpapers/set.jpg
wal -i /home/${username}/wallpapers/set.jpg
sleep 5s
norm_fg=$(cat ~/.cache/wal/colors-wal-dwm.h | grep "norm_fg\[\]" | awk '{print $6}')
norm_bg=$(cat ~/.cache/wal/colors-wal-dwm.h | grep "norm_bg\[\]" | awk '{print $6}')
norm_border=$(cat ~/.cache/wal/colors-wal-dwm.h | grep "norm_border\[\]" | awk '{print $6}')
sel_bg=$(cat ~/.cache/wal/colors-wal-dwm.h | grep "sel_bg\[\]" | awk '{print $6}')
urg_bg=$(cat ~/.cache/wal/colors-wal-dwm.h | grep "urg_bg\[\]" | awk '{print $6}')

sed -i "s/$old_norm_fg/$norm_fg/g" /home/$username/dwm-flexipatch/config.h
sed -i "s/$old_norm_bg/$norm_bg/g" /home/$username/dwm-flexipatch/config.h
sed -i "s/$old_norm_border/$norm_border/g" /home/$username/dwm-flexipatch/config.h
sed -i "s/$old_sel_bg/$sel_bg/g" /home/$username/dwm-flexipatch/config.h
sed -i "s/$old_urg_bg/$urg_bg/g" /home/$username/dwm-flexipatch/config.h

cd /home/$username/dwm-flexipatch && sudo make install
echo 'Done, restart your xorg.'
