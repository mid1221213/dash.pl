#! /usr/bin/perl

use strict;
use warnings;
use feature 'say';

use Net::Pcap;
use Net::Frame::Layer::ETH;

############################################
# Configuration

# The device you wish to listen to
# Normally the one connected to your
#   router / gateway

my $dev = 'eth1';

# List of buttons to detect
# You can leave it as is the first time,
#   press the button you want to detect,
#   then fill the hwaddr with the MAC
#   that has been detected.
#
# BEWARE: the action is executed as root!!!

my @buttons = (
    {
	hwaddr => 'b4:7c:9c:ce:8a:6c',
	name => 'SimpleHuman',
	action => 'ls -l',
    },
    {
	hwaddr => 'ac:63:be:38:6c:fe',
	name => 'ON',
	action => 'echo yeah',
    },
    );

############################################
# End of configuration

my $err = '';
my $net = '';
my $mask = '';
pcap_lookupnet($dev, \$net, \$mask, \$err);

# open the device for live listening
my $pcap = pcap_open_live($dev, 1024, 0, 0, \$err);

die $err if $err;

my $filter_str = 'udp and ( port 67 or port 68 )';
my $filter = '';
pcap_compile($pcap, \$filter, $filter_str, 1, $mask);
pcap_setfilter($pcap, $filter);

my $now = 0;

# infinite loop over matching packets
pcap_loop($pcap, -1, \&process_packet, 'JAPH');

sub process_packet {
    my ($user_data, $header, $packet) = @_;

    my $layer = Net::Frame::Layer::ETH->new(raw => $packet);
    $layer->unpack;

    foreach my $button_h (@buttons) {
	if ($layer->src eq $button_h->{hwaddr}) {
	    say "$button_h->{name} detected, launching [$button_h->{action}]";

	    my $newnow = time;
	    system($button_h->{action}) if $newnow - $now > 5;
	    $now = $newnow;

	    return;
	}
    }

    say 'button [' . $layer->src . '] detected!';
}
