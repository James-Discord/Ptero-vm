import subprocess

subprocess.call("chmod 755 vm.sh", shell=True)
subprocess.call("./vm.sh", shell=True)
