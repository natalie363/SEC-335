#! /bin/bash

# The additions to this script are fully my work

netPrefix=$1
port=$2

# checks if the user wants an output file, in addition to the results being printed to the screen
read -p "Would you like to save the output to a file? (y or n): " output_option
if [ $output_option == 'y' ] || [ $output_option == 'Y' ];
then
  read -p "Enter a name for your output file: " output_name
else
  echo "The results will only be printed to the screen"
fi

echo "ip,port"
for host in $(seq 1 254); do
    # if the user wanted an output file, writes to there in addition to the screen
    # if not, only writes to the screen
    if [ $output_option == 'y' ] || [ $output_option == 'Y' ];
    then
      timeout .1 bash -c "echo >/dev/tcp/$netPrefix.$host/$port" 2>/dev/null && echo "$netPrefix.$host,$port" && echo "$netPrefix.$host,$port" >> $output_name
    else
      timeout .1 bash -c "echo >/dev/tcp/$netPrefix.$host/$port" 2>/dev/null && echo "$netPrefix.$host,$port" 
    fi
done

