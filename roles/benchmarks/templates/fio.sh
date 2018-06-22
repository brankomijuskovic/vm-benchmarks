#!/bin/bash
TIME=$(date +%d-%m-%Y-%H-%M-%S)
# delete previous results ?, not needed maybe...
# rm -rf results-*.txt

RESULTRAND(){
        LATMSorUS=$(grep -i lat results-$TEST-$TIME.txt | grep -vE "(slat|clat|platform)" | grep avg | awk '{print $2}')
        LAT=$(grep -i lat results-$TEST-$TIME.txt | grep -vE "(slat|clat|platform)" | head -n 1 | awk -F ',' '{print $3}')
        BW=$(grep -i "bw=" results-$TEST-$TIME.txt | tr " " "\n" | grep BW)
        IOPS=$(grep -i "iops=" results-$TEST-$TIME.txt | tr " " "\n" | grep -i iops)
        echo "$IOPS $BW Lat$LATMSorUS $LAT"
        }

RESULTSEQ(){
        LATMSorUS=$(grep -i lat results-$TEST-$TIME.txt | grep -vE "(slat|clat|platform)" | grep avg | awk '{print $2}')
	LAT=$(grep -i lat results-$TEST-$TIME.txt | grep -vE "(slat|clat|platform)" | head -n 1 | awk -F ',' '{print $3}')
        BW=$(grep -i "bw=" results-$TEST-$TIME.txt | tr " " "\n" | grep bw)
        IOPS=$(grep -i "iops=" results-$TEST-$TIME.txt | tr " " "\n" | grep -i iops)
        echo "$BW $IOPS Lat$LATMSorUS $LAT"
        }


#Random read/write tests, in 4 variants (engine liabio vs. sync, and sync=0 vs sync=1 parameteres)
#liabio, sync=0
# ioengine=sync, iodepth always is 1 (no matter what we set it to)
# ioengine=libaio, iodepth is configurable (outstanding IO in the queue, per thread/job)
# numjobs = double the CPU ? 8 for inside single VM...
RANDREAD1(){ fio --runtime={{ fio_runtime }} --time_based --clocksource=clock_gettime --name=randread --iodepth=4 --numjobs={{ ansible_processor_vcpus }} --rw=randread --bs=4k --size={{ fio_size }} --ioengine=libaio --filename=fio.tmp --sync=0 --direct=1 --group_reporting > results-$TEST-$TIME.txt; }
RANDWRITE1(){ fio --runtime={{ fio_runtime }} --time_based --clocksource=clock_gettime --name=randwrite --iodepth=4 --numjobs={{ ansible_processor_vcpus }} --rw=randwrite --bs=4k --size={{ fio_size }} --ioengine=libaio --filename=fio.tmp --sync=0 --direct=1 --group_reporting > results-$TEST-$TIME.txt; }
#libaio, sync=1
RANDREAD2(){ fio --runtime={{ fio_runtime }} --time_based --clocksource=clock_gettime --name=randread --iodepth=4 --numjobs={{ ansible_processor_vcpus }} --rw=randread --bs=8k --size={{ fio_size }} --ioengine=libaio --filename=fio.tmp --sync=1 --direct=1 --group_reporting > results-$TEST-$TIME.txt; }
RANDWRITE2(){ fio --runtime={{ fio_runtime }} --time_based --clocksource=clock_gettime --name=randwrite --iodepth=4 --numjobs={{ ansible_processor_vcpus }} --rw=randwrite --bs=8k --size={{ fio_size }} --ioengine=libaio --filename=fio.tmp --sync=1 --direct=1 --group_reporting > results-$TEST-$TIME.txt; }


# Sequential read/write tests, no variants needed
SEQREAD(){ fio --runtime={{ fio_runtime }} --time_based --clocksource=clock_gettime --name=read --iodepth=4 --numjobs={{ ansible_processor_vcpus }} --rw=read --bs=64k --size={{ fio_size }} --ioengine=libaio --filename=fio.tmp --sync=0 --direct=1 --group_reporting > results-$TEST-$TIME.txt; }
SEQWRITE(){ fio --runtime={{ fio_runtime }} --time_based --clocksource=clock_gettime --name=write --iodepth=4 --numjobs={{ ansible_processor_vcpus }} --rw=write --bs=64k --size={{ fio_size }} --ioengine=libaio --filename=fio.tmp --sync=0 --direct=1 --group_reporting > results-$TEST-$TIME.txt; }


#echo "Starting FIO `date`"
#echo " "
#echo "#####################################################################################################################################################"
#echo "##### --iodepth=32 --numjobs=8 --bs=4k --size={{ fio_size }} --ioengine=libaio --sync=0 --direct=1 #####"
TEST=RANDOMREAD1
#echo " "
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo "### STARTING $TEST TEST..."
for run in {1..1};do echo 3 > /proc/sys/vm/drop_caches; RANDREAD1; RESULTRAND; done

TEST=RANDOMWRITE1
#echo " "
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo "### STARTING $TEST TEST..."
for run in {1..1};do echo 3 > /proc/sys/vm/drop_caches; RANDWRITE1; RESULTRAND; done
#echo " "
#echo " "
#echo "#####################################################################################################################################################"
#echo "##### --iodepth=32 --numjobs=8 --bs=8k --size={{ fio_size }} --ioengine=libaio --sync=1 --direct=1 #####"
TEST=RANDOMREAD2
#echo " "
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo "### STARTING $TEST TEST..."
for run in {1..1};do echo 3 > /proc/sys/vm/drop_caches; RANDREAD2; RESULTRAND; done

TEST=RANDOMWRITE2
#echo " "
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo "### STARTING $TEST TEST..."
for run in {1..1};do echo 3 > /proc/sys/vm/drop_caches; RANDWRITE2; RESULTRAND; done


#echo " "
#echo " "
#echo "#####################################################################################################################################################"
#echo "##### --iodepth=32 --numjobs=8 --bs=64k --size={{ fio_size }} --ioengine=libaio --sync=0 --direct=1 #####"

TEST=SEQREAD
#echo " "
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo "### STARTING $TEST TEST..."
for run in {1..1};do echo 3 > /proc/sys/vm/drop_caches; SEQREAD; RESULTSEQ; done

TEST=SEQWRITE
#echo " "
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo "### STARTING $TEST TEST..."
for run in {1..1};do echo 3 > /proc/sys/vm/drop_caches; SEQWRITE; RESULTSEQ; done

#touch /tmp/fio
