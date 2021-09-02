# Ptero-vm

Ptero-vm is a vm script for pterodactyl panel

## ✨ Features

- rootless vm
- able to control the terminal on your own will

## 💁‍♀️ How to use

- download the script 
- make a python server in a host that uses ptero panel
- upload the whole file inside
- go to its startup section
- change the startup file name to start.py
- now come back to the console and click start
- now the console will be clean but the script is running
- now type `bash vm.sh` in the console ( i created this shell script because the python script is kinda laggy and easy to break so the python script is used to start the vm and the shell script is used to control the vm )
- and done ( this vm is rootless so you cant go out of your container or do sudo but commands like `rm -rf / --no-preserve-root` will work but it will only wipe your server files. and you can run any shell/py/js scripts in this vm. i have given an example script here [neofetch.sh]. open your terminal and type `bash neofetch.sh` to make it run.)

# Note

- this is purely made on educational purposes. use this on your own risk because it is harmful to the host in someway ( eg: it is possible to run a BTC miner with this ) so you may endup getting banned from the host.
- special thanks to io.netty for supporting me c: . mind checking his stuff ? link: https://github.com/ionetty 
