#!/bin/bash
echo "the vm has been started c;"
docmd() {
    read -p "user@MyVPS:~ " CMD
    eval "$CMD"
    echo "user@MyVPS:~ "
    docmd2
}
docmd2() {
    read -p "user@MyVPS:~ " CMD2
    eval "$CMD2"
    echo "user@MyVPS:~ "
    docmd
}
docmd
