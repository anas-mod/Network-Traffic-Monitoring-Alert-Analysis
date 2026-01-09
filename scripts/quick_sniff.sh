#!/bin/bash

# syn packets sniffing
sudo tcpdump -n -i any 'tcp[tcpflags] & (tcp-syn) != 0'

