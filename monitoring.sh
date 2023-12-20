#!/bin/bash

# System information
arc=$(uname -a)
pcpu=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)
vcpu=$(grep -c processor /proc/cpuinfo)
# RAM
use_ram=$(free --mega | awk '$1 == "Mem:" {print $3}')
total_ram=$(free --mega | awk '$1 == "Mem:" {print $2}')
util_rate_ram=$(free --mega | awk '/^Mem:/ {printf("%.2f%%\n"), $3/$2*100}')

#Disk memory
use_disk=$(df -h --total | awk '/total/ {print $3}')
total_disk=$(df -h --total | awk '/total/ {print $2}')
util_rate_disk=$(df -h --total | awk '/total/ {print $5}')

# CPU utilization rate
util_rate_cpu=$(top -bn1 | awk '/^%Cpu/ {printf("%.1f%%\n"), $2 + $4}')

last_boot=$(who -b)
lvm_status=$(lsblk | grep -q lvm && echo active || echo inactive)
count_tcp=$(awk '/^TCP/ {print $3}' /proc/net/sockstat)
count_user=$(who | wc -l)
ip_address=$(hostname -I)
MAC_address=$(ip link show | awk '/link\/ether/ {print $2}')
count_sudo_cmd=$(journalctl _COMM=sudo | grep -c COMMAND)

#Display information:
wall "    	Architecture: $arc
    		Physical CPU: $pcpu
    		Virtual CPU: $vcpu
    		RAM infor: $use_ram / $total_ram ($util_rate_ram)
    		Disk memory: $use_disk /$total_disk ($util_rate_disk)
    		CPU utilization rate: $util_rate_cpu
    		Last boot: $last_boot
    		LVM status: $lvm_status
    		TCP connection: $count_tcp ESTABLISHED
    		Users: $count_user
    		Network: IPv4 address $ip_address
			MAC address: $MAC_address
    		Sudo commands: $count_sudo_cmd cmds"
