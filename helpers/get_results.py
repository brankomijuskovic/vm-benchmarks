from __future__ import print_function
import time
import socket
from os.path import expanduser

results_cpu = '/tmp/cpu.txt'
results_mem = '/tmp/mem.txt'
results_net = '/tmp/latency.txt'
results_fio = '/tmp/fio.txt'

cpu_time = ''
cpu_latency = ''
mem_time = ''
mem_latency = ''
net_latency = ''
fio_1 = ''
fio_2 = ''
fio_3 = ''
fio_4 = ''
fio_5 = ''
fio_6 = ''

result_file = '{0}/results.txt'.format(expanduser("~"))

blueprint = """Benchmark Results of VM {hostname} at {time}:

CPU Benchmark - The time to calculate prime numbers (Less is better)
Time:    {cpu_time}
Latency: {cpu_latency}

Memory Benchmark - The time to write random data to the memory (Less is better)
Time:    {mem_time}
Latency: {mem_latency}

Network Latency (Less is better)
Latency: {net_latency}

Disk FIO Benchmark (More is better)
Random Read 4K:       {fio_1}
Random Write 4K:      {fio_2}
Random Read 8K:       {fio_3}
Random Write 8K:      {fio_4}
Sequential Read 64K:  {fio_5}
Sequential Write 64K: {fio_6}
"""

with open(results_cpu, 'r') as cpu:
    lines = cpu.readlines()
    cpu_time = (lines[1].split()[2])
    cpu_latency = (lines[3].split()[2] + 'ms')

with open(results_mem, 'r') as mem:
    lines = mem.readlines()
    mem_time = (lines[1].split()[2])
    mem_latency = (lines[3].split()[2] + 'ms')

with open(results_net, 'r') as net:
    lines = net.readlines()
    if (lines[1].split()[5].rstrip('%')) == '100':
        net_latency = "Error, Packet loss = {0}".format(lines[1].split()[5])
    else:
        net_latency = (lines[2].split()[3].split('/')[1]) + (lines[2].split()[4].rstrip(','))


with open(results_fio, 'r') as fio:
    lines = fio.readlines()
    fio_1 = (lines[0].split()[0].rstrip(',') + ' ' + lines[0].split()[1] + ' ' + lines[0].split()[2].rstrip(':') + '='
             + lines[0].split()[3].split('=')[1])
    fio_2 = (lines[1].split()[0].rstrip(',') + ' ' + lines[1].split()[1] + ' ' + lines[1].split()[2].rstrip(':') + '='
             + lines[1].split()[3].split('=')[1])
    fio_3 = (lines[2].split()[0].rstrip(',') + ' ' + lines[2].split()[1] + ' ' + lines[2].split()[2].rstrip(':') + '='
             + lines[2].split()[3].split('=')[1])
    fio_4 = (lines[3].split()[0].rstrip(',') + ' ' + lines[3].split()[1] + ' ' + lines[3].split()[2].rstrip(':') + '='
             + lines[3].split()[3].split('=')[1])
    fio_5 = (lines[4].split()[1].rstrip(',') + '  ' + lines[4].split()[0].split('=')[0].upper() + '=' +
             lines[4].split()[0].split('=')[01] + ' ' + lines[4].split()[2].rstrip(':') +
             '=' + lines[4].split()[3].split('=')[1])
    fio_6 = (lines[5].split()[1].rstrip(',') + '  ' + lines[5].split()[0].split('=')[0].upper() + '=' +
             lines[5].split()[0].split('=')[01] + ' ' + lines[5].split()[2].rstrip(':') +
             '=' + lines[5].split()[3].split('=')[1])


results = (blueprint.format(cpu_time=cpu_time, cpu_latency=cpu_latency, mem_time=mem_time, mem_latency=mem_latency,
                            net_latency=net_latency, fio_1=fio_1, fio_2=fio_2, fio_3=fio_3, fio_4=fio_4, fio_5=fio_5,
                            fio_6=fio_6, hostname=socket.gethostname(), time=time.strftime("%c")))

with open(result_file, 'w') as r:
    print (results, file=r)
