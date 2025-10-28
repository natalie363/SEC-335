#! /bin/bash

# User Enumeration
echo "User Enumeration"
cut -d: -f1 /etc/passwd > allusers.txt
grep -v '/nologin\|/false' /etc/passwd | cut -d: -f1 > usersWithShells.txt
awk -F: '$3 == 0 {print $1}' /etc/passwd > rootUsers.txt

# Group Enumeration
echo "Group Enumeration"
cut -d: -f1 /etc/group > allgroups.txt
# getent group #groupname

# Network Connection Hunting
echo "Network Connection Hunting"
sudo ss -tuln > netConnections.txt 
sudo netstat -tunp | grep ESTABLISHED > estNetConnections.txt
sudo systemctl list-units --type=service --state=running | grep -E '(nc|ncat|socat|netcat)' > netServices.txt

# Process Hunting
echo "Process Hunting"
ps -ef > runningProcesses.txt
ps auxf > processTree.txt
ps aux | grep -E '(bash|sh|nc|ncat|python|perl)' > susProcesses.txt
ps aux | grep bash > processCommandLine.txt

# Service Enumeration
echo "Service Enumeration"
systemctl list-units --type=service > ServicesListing.txt
systemctl list-unit-files --type=service > allServicesListing.txt
systemctl list-unit-files --type=service --state=enabled > enabledServices.txt
systemctl list-unit-files --type=service --state=running > runningServices.txt

# Crontab & Scheduled Tasks Hunting
echo "Crontab & Scheduled Tasks Hunting"
sudo crontab -l > rootCrontab.txt
for user in $(cut -f1 -d: /etc/passwd); do 

    echo "=== Crontab for $user ===" >> userCrontab.txt

    sudo crontab -u $user -l 2>/dev/null >> userCrontab.txt

done
sudo cat /etc/crontab > etcCrontab.txt

# File Permission Hunting
echo "File Permissions"
sudo find / -type f -perm -002 2>/dev/null >> allWorldWriteable.txt
sudo find / -path /proc -prune -o -path /sys -prune -o -type f -perm -002 -print 2>/dev/null >> selectedWorldWriteable.txt

# SETUID/SETGID
echo "SETUID & SETGID"
find / -perm -4000 -type f 2>/dev/null >> suidFiles.txt
find / -perm -2000 -type f 2>/dev/null >> sgidFiles.txt
find / -perm -4000 -type f \! -user root 2>/dev/null > nonRootSUID.txt
find / -perm -4000 -perm -002 -type f 2>/dev/null > worldWriteableSUID.txt

# Bash History Hunting
echo "Bash History Hunting"
sudo cat /root/.bash_history > rootBashHistory.txt
for user_home in /home/*; do
    if [ -f "$user_home/.bash_history" ]; then
        echo "=== History for $(basename $user_home) ===" >> userBashHistory.txt
        cat "$user_home/.bash_history" >> userBashHistory.txt
    fi
done
sudo grep -E '(wget|curl|nc|chmod|base64|python.*http)' /root/.bash_history /home/*/.bash_history > suspiciousBashHistory.txt



