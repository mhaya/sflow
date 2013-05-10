#!/usr/bin/perl

use strict;
use POSIX;
use IO::Handle;
use RRDs;

my %header;
my %sflow;
my %count;
my $state = 0;

#auto flush
STDOUT->autoflush(1); 

while( <STDIN> ) {
    my ($attr,$value) = split;
    if($attr eq "startDatagram"){
        $state = 1;   
        next;
    }
    if($attr eq "startSample"){
        $state = 2;   
        next;
    }
    if($attr eq "endSample"){
        $state = 3;   
        process(\%header,\%sflow);
        %sflow=();
        next;
    }
    if($attr eq "endDatagram"){
        $state = 0;   
        %header=();   
    }
    if($state == 1){  
        $header{$attr}=$value;
    }
    if($state == 2){  
        $sflow{$attr}=$value;
    }
}

sub process{
    my($header,$sflow) = @_;
    my $datagramSize = $header->{'datagramSize'} ? $header->{'datagramSize'}:0;
    my $datagramSourceIP = $header->{'datagramSourceIP'} ? $header->{'datagramSo
urceIP'}:"";
    my $unixSecondsUTC = $header->{'unixSecondsUTC'} ? $header->{'unixSecondsUTC
'}:0;
    my $datagramVersion = $header->{'datagramVersion'} ? $header->{'datagramVers
ion'}:"";
    my $agent = $header->{'agent'} ? $header->{'agent'}:"";
    my $packetSequenceNo = $header->{'packetSequenceNo'} ? $header->{'packetSequ
enceNo'}:0;
    my $sysUpTime = $header->{'sysUpTime'} ? $header->{'sysUpTime'}:0;
    my $samplesInPacket = $header->{'samplesInPacket'} ? $header->{'samplesInPac
ket'}:0;
    my $sampleType_tag = $sflow->{'sampleType_tag'} ? $sflow->{'sampleType_tag'}
:"";
    my $sampleType = $sflow->{'sampleType'} ? $sflow->{'sampleType'}:"";
    my $sampleSequenceNo = $sflow->{'sampleSequenceNo'} ? $sflow->{'sampleSequen
ceNo'}:0;
    my $sourceId = $sflow->{'sourceId'} ? $sflow->{'sourceId'}:"";

    if($sampleType eq "COUNTERSSAMPLE"){
        my $statsSamplingInterval = $sflow->{'statsSamplingInterval'} ? $sflow->
{'statsSamplingInterval'} : 0;
        my $counterBlockVersion = $sflow->{'counterBlockVersion'} ? $sflow->{'co
unterBlockVersion'} : 0;
        my $ifIndex = $sflow->{'ifIndex'} ? $sflow->{'ifIndex'} : 0;
        my $networkType = $sflow->{'networkType'} ? $sflow->{'networkType'} : 0;
        my $ifSpeed = $sflow->{'ifSpeed'} ? $sflow->{'ifSpeed'} : 0;
        my $ifDirection = $sflow->{'ifDirection'} ? $sflow->{'ifDirection'} : 0;
        my $ifStatus = $sflow->{'ifStatus'} ? $sflow->{'ifStatus'} : 0;
        my $ifInOctets = $sflow->{'ifInOctets'} ? $sflow->{'ifInOctets'} : 0;
        my $ifInUcastPkts = $sflow->{'ifInUcastPkts'} ? $sflow->{'ifInUcastPkts'
} : 0;
        my $ifInMulticastPkts = $sflow->{'ifInMulticastPkts'} ? $sflow->{'ifInMu
lticastPkts'} : 0;
        my $ifInBroadcastPkts = $sflow->{'ifInBroadcastPkts'} ? $sflow->{'ifInBr
oadcastPkts'} : 0;
        my $ifInDiscards = $sflow->{'ifInDiscards'} ? $sflow->{'ifInDiscards'} :
 0;
        my $ifInErrors = $sflow->{'ifInErrors'} ? $sflow->{'ifInErrors'} : 0;
        my $ifInUnknownProtos = $sflow->{'ifInUnknownProtos'} ? $sflow->{'ifInUn
knownProtos'} : 0;
        my $ifOutOctets = $sflow->{'ifOutOctets'} ? $sflow->{'ifOutOctets'} : 0;
        my $ifOutUcastPkts = $sflow->{'ifOutUcastPkts'} ? $sflow->{'ifOutUcastPk
ts'} : 0;
        my $ifOutMulticastPkts = $sflow->{'ifOutMulticastPkts'} ? $sflow->{'ifOu
tMulticastPkts'} : 0; 
        my $ifOutBroadcastPkts = $sflow->{'ifOutBroadcastPkts'} ? $sflow->{'ifOu
tBroadcastPkts'} : 0; 
        my $ifOutDiscards = $sflow->{'ifOutDiscards'} ? $sflow->{'ifOutDiscards'
} : 0;
        my $ifOutErrors = $sflow->{'ifOutErrors'} ? $sflow->{'ifOutErrors'} : 0;
        my $ifPromiscuousMode = $sflow->{'ifPromiscuousMode'} ? $sflow->{'ifProm
iscuousMode'} : 0;
        print "CNTR,$unixSecondsUTC,$agent,$sampleType_tag,$sampleType,$sampleSe
quenceNo,$sourceId,$statsSamplingInterval,$counterBlockVersion,$ifIndex,$network
Type,$ifSpeed,$ifDirection,$ifStatus,$ifInOctets,$ifInUcastPkts,$ifInMulticastPk
ts,$ifInBroadcastPkts,$ifInDiscards,$ifInErrors,$ifInUnknownProtos,$ifOutOctets,
$ifOutUcastPkts,$ifOutMulticastPkts,$ifOutBroadcastPkts,$ifOutDiscards,$ifOutErr
ors,$ifPromiscuousMode\n";
    }

    if($sampleType eq "FLOWSAMPLE"){
        my $meanSkipCount = $sflow->{'meanSkipCount'} ? $sflow->{'meanSkipCount'
} : 0;
        my $inputPort = $sflow->{'inputPort'} ? $sflow->{'inputPort'}:0;
        my $sampledPacketSize = $sflow->{'sampledPacketSize'} ? $sflow->{'sample
dPacketSize'}:0;
        my $samplePool = $sflow->{'samplePool'} ? $sflow->{'samplePool'}:0;
        my $dropEvents = $sflow->{'dropEvents'} ? $sflow->{'dropEvents'}:0;
        my $outputPort = $sflow->{'outputPort'} ? $sflow->{'outputPort'}:0;
        my $flowSampleType = $sflow->{'flowSampleType'} ? $sflow->{'flowSampleTy
pe'}:"";
        my $headerProtocol = $sflow->{'headerProtocol'} ? $sflow->{'headerProtoc
ol'}:0;
        my $headerLen = $sflow->{'headerLen'} ? $sflow->{'headerLen'}:0;
        my $dstMAC = $sflow->{'dstMAC'} ? $sflow->{'dstMAC'}:"";
        my $srcMAC = $sflow->{'srcMAC'} ? $sflow->{'srcMAC'}:0;
        my $decodedVLAN = $sflow->{'decodedVLAN'} ? $sflow->{'decodedVLAN'}:0;
        print "L2,$unixSecondsUTC,$agent,$sourceId,$packetSequenceNo,$sampleSequ
enceNo,$samplesInPacket,$meanSkipCount,$samplePool,$dropEvents,$inputPort,$outpu
tPort,$flowSampleType,$headerProtocol,$sampledPacketSize,$headerLen,$srcMAC,$dst
MAC,$decodedVLAN\n";  
        if($sflow->{'IPProtocol'}){
            my $IPSize = $sflow->{'IPSize'} ? $sflow->{'IPSize'}:0;
            my $IPProtocol = $sflow->{'IPProtocol'} ? $sflow->{'IPProtocol'}:0;
            my $srcIP = $sflow->{'srcIP'} ? $sflow->{'srcIP'}:$sflow->{'srcIP6'}
 ? $sflow->{'srcIP6'}:"";
            my $dstIP = $sflow->{'dstIP'} ? $sflow->{'dstIP'}:$sflow->{'dstIP6'}
 ? $sflow->{'dstIP6'}:"";
            my $val = $sflow->{'IPProtocol'};
            $count{$agent}{'IPProtocol'}{$val} = $sampledPacketSize*$meanSkipCou
nt;
            #IP
            if($sflow->{'srcIP'}){
                my $src= $sflow->{'srcIP'};
                my $dst= $sflow->{'dstIP'};
                my $srcP;
                my $dstP;
                if($val==6){
                    $srcP= $sflow->{'TCPSrcPort'};
                    $dstP= $sflow->{'TCPDstPort'};
                }
                if($val==17){
                    $srcP= $sflow->{'UDPSrcPort'};
                    $dstP= $sflow->{'UDPDstPort'};
                }
                print "L3,$unixSecondsUTC,$agent,$sourceId,$packetSequenceNo,$sampleSequenceNo,$samplesInPacket,$meanSkipCount,$samplePool,$dropEvents,$inputPort,$outputPort,$flowSampleType,$headerProtocol,$sampledPacketSize,$headerLen,$srcMAC,$dstMAC,$decodedVLAN,$IPProtocol,$src,$dst,$srcP,$dstP\n";
            }
        }
    }
}

