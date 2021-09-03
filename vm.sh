#!/bin/bash
echo
echo getting the script ready...
sleep 1
echo ...Done
echo
echo making some coffee for giyu...
sleep 0.7
echo ..Done
echo
echo making more coffee...
sleep 0.5
echo ..Done
echo
echo Logging In to the vm...
sleep 0.2
echo ..Done


sleep 1
echo
echo ==== { Ptero-vm } ====
echo
sleep 1

echo
echo DISK SPACE CHECKUP:
echo
space_free=$( df -h | awk '{ print $5 }' | sort -n | tail -n 1 | sed 's/%//' )
case $space_free in
[1-5]*)
echo Plenty of disk space available
;;
[6-7]*)
echo There could be a problem in the near future
;;
8*)
echo Maybe we should look at clearing out old files
;;
9*)
echo We could have a serious problem on our hands soon
;;
*)
echo Something is not quite right here
;;
esac

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
