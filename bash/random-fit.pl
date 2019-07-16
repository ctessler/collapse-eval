#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $USAGE = << 'EOM';
Usage: random-fit.pl -f <FILE> -u (0,+inf] [OPTIONS]
OPTIONS:
	--file/-f <FILE>	Name of the file with the usage/taskname pairs
	--util/-u <FLOAT>	Target utilization
EOM

# False entrypoint for perl
sub main {
    my %opts = ( file => "",
		 tgtu => 0.0,
		 jitr => 5
    );

    GetOptions("file=s" => \$opts{file},
	       "util=f" => \$opts{tgtu},
	)
	or die($USAGE);

    if ($opts{tgtu} == 0.0) {
	die($USAGE);
    }

    my %data;
    open(my $fh, '<', $opts{file}) or die ("Could not open $opts{file}\n");
    while (my $line = <$fh>) {
	chomp($line);
	my ($u, $n);
	($u, $n) = split(/\s+/, $line);
	push @{$data{$u}}, $n;
    }
    close ($fh);

    my @utils = sort keys %data;
    my $i=0;
    if ($opts{tgtu} < $utils[0]) {
	$i = 0;
    } else {
	do {
	    $i = int(rand($#utils + 1));
	} while ($utils[$i] > $opts{tgtu});
    }
    my $u = $utils[$i];
	
    # Select a random task with that utilization
    my @tasks = @{$data{$u}};
    $i = int(rand($#tasks + 1));
    print "$u $tasks[$i]\n";
	
    return 0;
}
exit main()

