#!/usr/bin/perl

use strict;
use warnings;
use FindBin;

use Test::More;

BEGIN {
    {
        local $@;
        eval "use Plack;";
        plan skip_all => "Plack is required for this test" if $@;
    }
}

use Plack::Server::FCGI::Engine;
use Test::TCP;
use Plack::Test::Suite;
use t::lib::FCGIUtils;

my $http_port;
my $fcgi_port;

test_fcgi_standalone(
   sub {
       ($http_port, $fcgi_port) = @_;
       Plack::Test::Suite->run_server_tests(\&run_one, $fcgi_port, $http_port);
       done_testing();
    }
);

sub run_one {
    my($port, $app) = @_;
    my $server = Plack::Server::FCGI::Engine->new(
        host        => '127.0.0.1',
        port        => $port,
        pidfile     => '/tmp/101_plack_server_fcgi_engine_client.pid',
        keep_stderr => 1,
    );
    $server->run($app);
}


