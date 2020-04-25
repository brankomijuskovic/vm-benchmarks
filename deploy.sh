#!/bin/bash
# Script for deploying CPU, Memory, Network latency and Disk benchmarks
# @21.6.2018 Branko Mijuskovic

repo='https://github.com/brankomijuskovic/vm-benchmarks.git'
dir='vm-benchmarks'

yum -y install epel-release
yum -y install git ansible

if [ -d $dir ]; then
	cd $dir
	git pull $repo
	ansible-playbook benchmarks.yml
else
	git clone $repo
	cd vm-benchmarks
	ansible-playbook benchmarks.yml
fi

python helpers/get_results.py

while getopts ":m:" option; do
        case "${option}" in
		m) cat ~/results.txt | mailx -s "Benchmark results from $(hostname)" ${OPTARG};;
        esac
done

cat ~/results.txt
