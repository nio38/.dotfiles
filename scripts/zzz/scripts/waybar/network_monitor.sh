#!/bin/bash
INTERFACE=$(ip route | grep '^default' | awk '{print $5}')
RX=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
TX=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes)

sleep 1

RX_NEW=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
TX_NEW=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes)

RX_RATE=$(( (RX_NEW - RX) / 1024 ))
TX_RATE=$(( (TX_NEW - TX) / 1024 ))

echo -e "   $RX_RATE      $TX_RATE"
