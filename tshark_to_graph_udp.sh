#!/bin/bash
#tshark -r yourpcap.pcap -q -z conv,up >> UDP_streams.txt

cat UDP_streams.txt | grep -v -e [a-zA-Z]| grep -v \= >> udpsessions.tmp

while IFS= read -r line
do

SRCIP=$(echo $line | awk -F " " '{print $1}' |awk -F: '{print $1}')
DSTIP=$(echo $line | awk -F " " '{print $3}' |awk -F: '{print $1}')
DSTPORT=$(echo $line | awk -F " " '{print $3}' |awk -F: '{print $2}')

#Destination port graphical definitions
if [ "$DSTPORT" == "161" ]
then
colour="red"
elif [ "$DSTPORT" == "162" ]
then
colour="red"
elif [ "$DSTPORT" == "514" ]
then
colour="red"
elif [ "$DSTPORT" == "53" ]
then
colour="green"
elif [ "$DSTPORT" == "123" ]
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
shape2="oval"
colour3="gold1"
fi


echo "\"$SRCIP\" -> \"$DSTIP\" [label =$DSTPORT, color=$colour, weight=1, penwidth=2, fontsize=18]">> map.tmp
echo \"$DSTIP\" [shape= $shape, style = filled, fillcolor=$colour2]>> map.tmp
echo \"$SRCIP\" [shape= $shape2, style = filled, fillcolor=$colour3]>> map.tmp

done < udpsessions.tmp


#PICS
cat map.tmp |sort|uniq >> map_clean.tmp
echo "digraph IPCONV {" > udpmap.dot
echo "subgraph clusterHeader {" >> udpmap.dot
echo "margin=0" >> udpmap.dot
echo 'style="invis"'>> udpmap.dot
echo 'HEADER [shape="box", label=UDPCONNECTIONS];'  >> udpmap.dot 
echo "}" >> udpmap.dot
cat map_clean.tmp >> udpmap.dot
echo "}" >> udpmap.dot

echo "Generating pictures..."
DOT=/usr/bin/dot

$DOT -Tsvg -Kfdp udpmap.dot -o udpmap-fdp.svg
rm *.tmp

