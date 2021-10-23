#!/bin/bash

port=`ip -o link show |awk -F':' '{print $2}' | tr  '\n' " " | cut -d " " -f4`


while true;
do
        R1=$(cat /sys/class/net/$port/statistics/rx_bytes)
        S1=$(cat /sys/class/net/$port/statistics/tx_bytes)
        sleep 1
        R2=$(cat /sys/class/net/$port/statistics/rx_bytes)
        S2=$(cat /sys/class/net/$port/statistics/tx_bytes)

        rtot=$(( (R2 - R1) / 1024 ))
        stot=$(( (S2 - S1) / 1024 ))
        totR=$(( R1 / 1024 / 1024 ))
        totS=$(( S1 / 1024 / 1024 ))

        if [ "$rtot" -lt 1024 ] && [ "$stot" -lt 1024 ]
        then
                echo -en "\r$rtot KB/s  $stot KB/s  Received/Sent: $totR MB / $totS MB" 
        else
                tot=$(m=$((R2 - R1)) ;m2=$(echo $m / 1024 / 1024 | bc -l) ; printf "%.2f" $m2)
                tot2=$(mm=$((S2 - S1)) ;mm2=$(echo $mm / 1024 / 1024 | bc -l) ; printf "%.2f" $mm2)
                echo -en "\r$tot MB/s  $tot2 MB/s Received/Sent: $totR MB / $totS MB"



        fi;
done
