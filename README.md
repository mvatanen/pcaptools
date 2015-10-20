# pcaptools
Tools for pcap (network capture) analysis

#pcap_to_graph

pcap_to_graph_tcp.sh and pcap_to_graph_udp.sh are simple scripts that generates a picture from tshark output.

Commands to produce needed output from pcap file is:

tshark -r yourpcap.pcap -q -z conv,tcp  >> TCP_streams.txt     or

tshark -r yourpcap.pcap -q -z conv,up >> UDP_streams.txt

Inside the script you can define colours and shapes you wan't to use.

There are also two files needed, which however can be empty:

goodip.txt (IP addresses like internal ones etc.)
badip.txt (external or otherwise intersting addresses)
