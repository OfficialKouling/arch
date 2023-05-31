#!/bin/bash
exec sfdisk /dev/sda <<EOF
2048,1048576
,83886080
;
EOF
