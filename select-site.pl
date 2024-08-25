use warnings;
use strict;

use Data::Dumper;
use File::Find;
use IO::Prompter;
use YAML qw'LoadFile';

# Get the domain name for this project from public.yml

my $group_vars = LoadFile( '/group_vars/all/public.yml' );
my $domain = $group_vars->{domain_name};

# Get the subdomains configured for this project correlated to their hosts

my %sites = ();

sub host_vars {

    if ( $_ eq 'public.yml' ) {

        my $host = substr $File::Find::dir, 11; # Everything after "/host_vars/"
        my $host_vars = LoadFile( $File::Find::name );

        if ( exists $host_vars->{wp_subdomain} ) {

            $sites{$host_vars->{wp_subdomain}} = $host;

        } else {

            # Work needed to cater for instances of multiple subdomains for a
            # WordPress site implemented on the same host.

        }

    }

}

find( \&host_vars, ( '/host_vars' ) );

# Prompt for user selection of subdomain to restore

my @sites = sort keys %sites;

my $subdomain =
    prompt
        'Choose the subdomain of the site that you want to restore from:',
        -menu => \@sites,
        '>';

my $fqdn = "${subdomain}.${domain}";
(my $db = $fqdn) =~ s/\./_/g;

# Output environment variables required for the bconsole commands

open my $fh, '>', 'vars.sh' or die "Can't open > vars.sh: $!";
print $fh 'DB=', "$db\n";
print $fh 'FQDN=', "$fqdn\n";
print $fh 'HOST=', "$sites{$subdomain}\n";
close $fh;
