# Vm-benchmarks
CPU, Memory, Network latency (Ping) and Disk (FIO) benchmarks.
CentOS 7 is the only OS supported for now.

# Usage:
curl -sO https://raw.githubusercontent.com/ipcurl/vm-benchmarks/master/deploy.sh && bash deploy.sh [-m youremailadress@yourdomain.com]

The script requires root access.

If Email address is specified (-m flag), the benchmark results will be send to the email address via localhost mail server (check your spam folder if you don't find it in the inbox).
In either case the results will be printed to stout and recorded in ~/results.txt

To benchmark non-root partition/volume - cd to the mounted volume and run the script.
