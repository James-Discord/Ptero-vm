#!/bin/bash

 bold=`echo -en "\e[1m"`
 normal=`echo -en "\e[0m"`
 lightblue=`echo -en "\e[94m"`
 lightgreen=`echo -en "\e[92m"`
 
clear

echo "
========================================================================

  _____    _                                     __      __  __  __ 
 |  __ \  | |                                    \ \    / / |  \/  |
 | |__) | | |_    ___   _ __    ___      ______   \ \  / /  | \  / |
 |  ___/  | __|  / _ \ | '__|  / _ \    |______|   \ \/ /   | |\/| |
 | |      | |_  |  __/ | |    | (_) |               \  /    | |  | |
 |_|       \__|  \___| |_|     \___/                 \/     |_|  |_|
                                                                                                                
========================================================================
 "
                                                                     
echo
echo getting the script ready...
sleep 3
echo ...Done
echo
echo making some coffee for giyu...
sleep 0.5
echo ..Done
echo
echo Logging In to the vm...
sleep 0.2
echo ..Done

echo
sleep 1

echo

sleep 1
echo
echo
echo "the vm has been started c;"
docmd() {
    read -p "${bold}${lightgreen}default${normal}@${lightblue}Ptero-vm:~${normal} " CMD
    eval "$CMD"
    docmd2
}
docmd2() {
    read -p "${bold}${lightgreen}default${normal}@${lightblue}Ptero-vm:~${normal} " CMD2
    eval "$CMD2"
    docmd
}
docmd
