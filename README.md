
#pcap_to_graph

pcap_to_graph_tcp.sh and pcap_to_graph_udp.sh are simple scripts that generates a coloured picture from tshark output.

Commands to produce needed output from pcap file is:

tshark -r yourpcap.pcap -n -q -z conv,tcp  >> TCP_streams.txt     or

tshark -r yourpcap.pcap -n -q -z conv,udp >> UDP_streams.txt

All syn packets (tcpdump) and tdump_to_graph.sh

tcpdump -nn -r your.pcap "tcp[13] == 2" >>synprobes.txt


Inside the script you can define colours and shapes you wan't to use based on destination port, destination ip or source ip.

There are also two files needed, which however can be empty:

goodip.txt (IP addresses like internal ones etc.)

badip.txt (external or otherwise interesting addresses)
