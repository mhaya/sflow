About:

"sFlowToolParser.pl" is a perl script for the InMon sFlowToolkit(http://www.inmon.com/technology/sflowTools.php). It converts the sflowtool output format into a CSV format which is more detailed than the default line-by-line format.

How to use:

$ ./sflowtool | perl sFlowToolParser.pl
CNTR,1379398601,192.168.0.6,0:2,COUNTERSSAMPLE,34,0:2,0,0,2,6,100000000,1,3,31689,363,20,11,0,0,0,49078,611,0,0,0,0,1
L2,1379398603,192.168.0.6,0:2,35,1,1,512,1021,0,2,1073741823,HEADER,1,102,98,00a0de154fb5,000c2952a44a,0
L3,1379398603,192.168.0.6,0:2,35,1,1,512,1021,0,2,1073741823,HEADER,1,102,98,00a0de154fb5,000c2952a44a,0,6,192.168.1.3,192.168.0.6,111,43761

Output Format:

1. COUNTER SAMPLE format:
(1)CNTR,(2)unixSecondsUTC,(3)agent,(4)sampleType_tag,(5)sampleType,(6)sampleSequenceNo,(7)sourceId,(8)statsSamplingInterval,(9)counterBlockVersion,(10)ifIndex,(11)networkType,(12)ifSpeed,(13)ifDirection,(14)ifStatus,(15)ifInOctets,(16)ifInUcastPkts,(17)ifInMulticastPkts,(18)ifInBroadcastPkts,(19)ifInDiscards,(20)ifInErrors,(21)ifInUnknownProtos,(22)ifOutOctets,(23)ifOutUcastPkts,(24)ifOutMulticastPkts,(25)ifOutBroadcastPkts,(26)ifOutDiscards,(27)ifOutErrors,(28)ifPromiscuousMode

example:
$ ./sflowtool | perl sFlowToolParser.pl|awk -F',' '$3=="192.168.0.6"&&$7=="0:2"{print "rrdtool update traffic.rrd "$2":"$15":"$22}


2. FLOW SAMPLE Format(L2):
(1)L2,(2)unixSecondsUTC,(3)agent,(4)sourceId,(5)packetSequenceNo,(6)sampleSequenceNo,(7)samplesInPacket,(8)meanSkipCount,(9)samplePool,(10)dropEvents,(11)inputPort,(12)outputPort,(13)flowSampleType,(14)headerProtocol,(15)sampledPacketSize,(16)headerLen,(17)srcMAC,(18)dstMAC,(19)decodedVLAN

3. FLOW SAMPLE Format(L3):
(1)L3,(2)unixSecondsUTC,(3)agent,(4)sourceId,(5)packetSequenceNo,(6)sampleSequenceNo,(7)samplesInPacket,(8)meanSkipCount,(9)samplePool,(10)dropEvents,(11)inputPort,(12)outputPort,(13)flowSampleType,(14)headerProtocol,(15)sampledPacketSize,(16)headerLen,(17)srcMAC,(18)dstMAC,(19)decodedVLAN,(20)IPProtocol,(21)src,(22)dst,(23)srcP,(24)dstP


