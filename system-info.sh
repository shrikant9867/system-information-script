#!/bin/bash
echo -e "-------------------------------System Information----------------------------"
echo -e "Hostname:\t\t"`hostname`
echo -e "uptime:\t\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`
echo -e "Product Name:\t\t"`cat /sys/class/dmi/id/product_name`
echo -e "Version:\t\t"`cat /sys/class/dmi/id/product_version`
echo -e "Serial Number:\t\t"`cat /sys/class/dmi/id/product_serial`
echo -e "Machine Type:\t\t"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`
echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
echo -e "Kernel:\t\t\t"`uname -r`
echo -e "Architecture:\t\t"`arch`
echo -e "Processor Name:\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
echo -e "Active User:\t\t"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`
echo -e "System Main IP:\t\t"`hostname -I`
echo ""
echo -e "-------------------------------CPU/Memory Sizes Details ---------------------"

echo -e "RAM  Size: \t"`free -m | awk '/Mem/{printf("%.2fMB"),$2 }'`
echo -e "SWAP Size: \t"`free -m | awk '/Swap/{printf("%.2fMB"),$2 }'`
echo -e "CPU threads:\t" `nproc --all`
echo ""

echo -e "-------------------------------CPU/Memory Usage------------------------------"
echo -e "Memory Usage:\t"`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}'`
echo -e "Swap Usage:\t"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}'`
echo -e "CPU Usage:\t"`cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' |  awk '{print $0}' | head -1`
echo ""
echo -e "-------------------------------Current top 10 Memory and CPU Usage-----------"
ps -eo pid,ppid,%mem,%cpu,cmd --sort=-%mem | head -n 11
echo ""

echo -e "-------------------------------Disk Usage >50%-------------------------------"
df -h | sed s/%//g | awk '{ if($5 > 50) print $0;}'
echo ""

echo -e "-------------------------------Disk Partition Details------------------------"
df -PhT
echo ""

echo -e "-------------------------------For WWN Details-------------------------------"
vserver=$(lscpu | grep Hypervisor | wc -l)
if [ $vserver -gt 0 ]
then
echo "$(hostname) is a VM"
else
cat /sys/class/fc_host/host?/port_name
fi
echo ""

# echo -e "-------------------------------Package Updates-------------------------------"
# if [ -f /etc/redhat-release ]; then
#   yum updateinfo summary | grep 'Security|Bugfix|Enhancement'
# fi

# if [ -f /etc/lsb-release ]; then
#   apt-get update | grep 'Security|Bugfix|Enhancement'
# fi
# echo -e "-----------------------------------------------------------------------------"

echo -e "-------------------------------Package Updates-------------------------------"
cat /var/lib/update-notifier/updates-available
echo -e "-----------------------------------------------------------------------------"
