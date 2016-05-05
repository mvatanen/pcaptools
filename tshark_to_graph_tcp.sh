#!/bin/bash
#https://github.com/mvatanen
#tshark -r yourpcap.pcap -n -q -z conv,up >> TCP_streams.txt

cat TCP_streams.txt | grep -v -e [a-zA-Z]| grep -v \= >> tcpsessions.tmp

while IFS= read -r line
do

SRCIP=$(echo $line | awk -F " " '{print $1}' |awk -F: '{print $1}')
DSTIP=$(echo $line | awk -F " " '{print $3}' |awk -F: '{print $1}')
DSTPORT=$(echo $line | awk -F " " '{print $3}' |awk -F: '{print $2}')

#Destination port graphical definitions
if [ "$DSTPORT" == "80" ]
then
colour="red"
elif [ "$DSTPORT" == "21" ]
then
colour="red"
elif [ "$DSTPORT" == "23" ]
then
colour="red"
elif [ "$DSTPORT" == "443" ]
then
colour="green"
elif [ "$DSTPORT" == "22" ]
then
colour="green"
else
colour="black"
fi

#Destination IP graphical definitions
if [ "$DSTIP" == "`grep $DSTIP badip.txt`" ]
then
shape="diamond"
colour2="red3"
else 
shape="box"
colour2="cyan"
fi

#Source IP graphical definitions
if [ "$SRCIP" == "`grep $SRCIP goodip.txt`" ]
then
shape2="ellipse"
colour3="yellow"
else 
shape="box"
colour2="cyan"
fi


echo "\"$SRCIP\" -> \"$DSTIP\" [label =$DSTPORT, color=$colour, weight=1, penwidth=2, fontsize=18]">> map.tmp
echo \"$DSTIP\" [shape= $shape, style = filled, fillcolor=$colour2]>> map.tmp
echo \"$SRCIP\" [shape= $shape2, style = filled, fillcolor=$colour3]>> map.tmp

done < tcpsessions.tmp


#PICS
cat map.tmp |sort|uniq >> map_clean.tmp
echo "digraph IPCONV {" > tcpmap.dot
echo "subgraph clusterHeader {" >> tcpmap.dot
echo "margin=0" >> tcpmap.dot
echo 'style="invis"'>> tcpmap.dot
echo 'HEADER [shape="box", label=TCPCONNECTIONS];'  >> tcpmap.dot 
echo "}" >> tcpmap.dot
cat map_clean.tmp >> tcpmap.dot
echo "}" >> tcpmap.dot

echo "Generating pictures..."
DOT=/usr/bin/dot

$DOT -Tsvg -Kfdp tcpmap.dot -o tcpmap-fdp.svg
rm *.tmp

