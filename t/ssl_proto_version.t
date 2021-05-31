#!/usr/bin/perl

use warnings;
use Test::More;
use FindBin qw($Bin);
use lib "$Bin/lib";
use MemcachedTest;

if (!enabled_tls_testing()) {
    plan skip_all => 'SSL testing is not enabled';
    exit 0;
}

my $server = new_memcached('-o ssl_min_version=2');

# Minimum supported protocol version
$sock = $server->new_sock(undef, 'TLSv1_2');
print $sock "version\r\n";
like(scalar <$sock>, qr/VERSION/, "handshake with minimum proto version");

# Above minimum supported protocol version
$sock = $server->new_sock(undef, 'TLSv1_3');
print $sock "version\r\n";
like(scalar <$sock>, qr/VERSION/, "handshake above minimum proto version");

$server = new_memcached('-o ssl_min_version=3');

# Unsupported protocol version
$sock = $server->new_sock(undef, 'TLSv1_2');
is(undef, $sock, "handshake failure on unsupported proto version");

done_testing();
