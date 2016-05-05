#!/bin/bash
#https://github.com/mvatanen
#tcpdump -nn -r your.pcap "tcp[13] == 2" >>synprobes.txt

while IFS= read -r line
do

SRCIP=$(echo $line | awk -F " " '{print $3}' |cut -d. -f 1,2,3,4)
DSTIP=$(echo $line | awk -F " " '{print $5}' |cut -d. -f 1,2,3,4)
DSTPORT=$(echo $line | awk -F " " '{print $5}' |cut -d. -f 5|tr -d :)

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


echo "\"$SRCIP\" -> \"$DSTIP\" [label =$DSTPORT, color=$colour, weight=1, penwidth=2, fontsize=18]">> synmap.tmp
echo \"$DSTIP\" [shape= $shape, style = filled, fillcolor=$colour2]>> synmap.tmp
echo \"$SRCIP\" [shape= $shape2, style = filled, fillcolor=$colour3]>> synmap.tmp

done < synprobes.txt


#PICS
cat synmap.tmp |sort|uniq >> synmap_clean.tmp
echo "digraph SYNPROBES {" > synmap.dot
echo "subgraph clusterHeader {" >> synmap.dot
echo "margin=0" >> synmap.dot
echo 'style="invis"'>> synmap.dot
echo 'HEADER [shape="box", label=SYNPACKETS];'  >> synmap.dot 
echo "}" >> synmap.dot


cat synmap_clean.tmp >> synmap.dot
echo "}" >> synmap.dot
echo "Generating pictures..."
DOT=/usr/bin/dot

$DOT -Tsvg -Kfdp synmap.dot -o synmap-fdp.svg
rm *.tmp

