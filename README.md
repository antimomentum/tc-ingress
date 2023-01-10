## Deep packet inspection with tc made easier :)


The test script is intended to make writing tc ingress rules for deep packet inspection easier. Also includes a length check first to help with efficiency. 




u32 in iptables and "match u32" in tc both grab 4 bytes at a time by default. If you only want to match 3 bytes change an ff to 00 in the test script.



This script expects 4 arguments:

1. The interface name you want to make the rule on.


2. The "Total Length" of the packet you want to do the byte check on. For instance if the packet is 48 bytes then use "48" for this argument


3.  We use iptables u32 default syntax here. So the byte number or offset you want to start the 4 byte check from is on the left side of the "=" and the 4 bytes to match go on the right side. For example "35=0x0a010308" means:
    starting at byte 35 in the packet look for these 4 bytes: 0103080a.


4. The action. This will usually just be either "pass" or "drop" but tc does have others.



So an example to generate a tc rule checking for bytes 0103080a starting at byte number 35 in the packet would be:

    ./test.sh eth0 48 "36=0103080a" drop


In out.txt you will see the rule generated. Keep in mind this script has little testing so out.txt is intentionally not made executable automatically and you should look over and test any rules it generates before relying on them. Be sure to read the script notes too!


Tested in Debian 10 only so far. More tc stuff will probably be added to this repo.




## Known bugs


For some reason the u32 match filter in tc seems to have issues with odd number bytes to check for in nexthdr.


For example, a rule ending in nexthdr+35 will not work but nexthdr+36 will execute and actually match the specified packets.


If you generate a rule that won't work tc will simply output: Illegal "match"


Otherwise if you see no output the command was successful and will begin looking for matches.
