#!/bin/bash
echo "
========================================================================

 _______ _________ _______  _______  _______                  _______ 
(  ____ )\__   __/(  ____ \(  ____ )(  ___  )       |\     /|(       )
| (    )|   ) (   | (    \/| (    )|| (   ) |       | )   ( || () () |
| (____)|   | |   | (__    | (____)|| |   | | _____ | |   | || || || |
|  _____)   | |   |  __)   |     __)| |   | |(_____)( (   ) )| |(_)| |
| (         | |   | (      | (\ (   | |   | |        \ \_/ / | |   | |
| )         | |   | (____/\| ) \ \__| (___) |         \   /  | )   ( |
|/          )_(   (_______/|/   \__/(_______)          \_/   |/     \| 

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
    read -p "default@Ptero-vm:~ " CMD
    eval "$CMD"
    docmd2
}
docmd2() {
    read -p "default@Ptero-vm:~ " CMD2
    eval "$CMD2"
    docmd
}
docmd
