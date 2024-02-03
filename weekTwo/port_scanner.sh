#! /bin/bash

# The additions to this script are fully my work

hostfile=$1
portfile=$2

# check if the file exists and has content
if [ -r $hostfile ] && [ -s $hostfile ];
then
  # confirms with the user that the file is correct, if not, lets them select a new file
  read -p "Is the file $hostfile the correct host file (y or n): " host_check
  if [ $host_check == 'y' ] || [ $host_check == 'Y' ];
  then 
    echo "Thanks for confirming!"
  else
    read -p "Enter the new hostfile name: " hostfile
  fi
# if the file is not there, cannot be read, or is empty, get new filename
else
  echo "The hostfile either does not exist, is empty, or does not have read permissions" 
  read -p "Enter a new hostfile name: " hostfile
fi

# checks if the file exists and has content
if [ -s $portfile ] && [ -r $portfile ];
then
  # confirms with the user that the file is correct, if not, lets them select a new file
  read -p "Is the file $portfile the correct port file (y or n): " port_check
  if [ $port_check == 'y' ] || [ $port_check == 'Y' ];
  then
    echo "Thanks for confirming!"
  else
    read -p "Enter the new portfile name: " portfile
  fi
# if the file is not there, cannot be read, or is empty, gets a new filename
else
  echo "The portfile either does not exist, is empty, or does not have read permissions"
  read -p "Enter the new portfile name: " portfile
fi

# checks if the user wants an output file, in addition to the results being printed to the screen
read -p "Would you like to save the output to a file? (y or n): " output_option
if [ $output_option == 'y' ] || [ $output_option == 'Y' ];
then
  read -p "Enter a name for your output file: " output_name
else
  echo "The results will only be printed to the screen"
fi

echo "host,port"
for host in $(cat $hostfile); do
  for port in $(cat $portfile); do
    # if the user wanted an output file, writes to there in addition to the screen
    # if not, only writes to the screen
    if [ $output_option == 'y' ] || [ $output_option == 'Y' ];
    then
      timeout .1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null && echo "$host,$port" && echo "$host,$port" >> $output_name
    else
      timeout .1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null && echo "$host,$port" 
    fi
  done
done

