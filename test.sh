#!/bin/bash

# Check if required parameters are present
if [ $# -ne 4 ]; then
  echo "Usage: $0 <interface> <length> <u32 string> <action>"
  exit 1
fi

# Arguments
interface=$1
length=$2
u32_string=$3
action=$4

# Add ingress qdisc to the interface. Something like the following line would be REQUIRED to make any ingress rules.
# tc qdisc add dev $interface ingress

# Extract the match values from the u32 string
u32_match=${u32_string#*=}
u32_offset=${u32_string%=*}

# Create the tc filter ingress rule for ipv4 packets :)
echo "tc filter add dev $interface parent ffff: protocol ip u32 \
  match u16 $length 0xffff at 2 \
  match u32 $u32_match 0xffffffff at nexthdr+$u32_offset \
  action $action" > out.txt
