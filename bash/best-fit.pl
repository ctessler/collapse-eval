#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $USAGE = << 'EOM';
Usage: best-fit.pl -f <FILE> -u [0,1] [OPTIONS]
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
    # Find the best utilization
    my $i;
    for ($i=0; $i <= $#utils; $i++) {
	if ($utils[$i] >= $opts{tgtu}) {
	    last;
	}
    }
    $i = $#utils if ($i > $#utils);
    # Save the utilization
    my $u=$utils[$i];

    # Select a random task with that utilization
    my @tasks = @{$data{$u}};
    $i = int(rand($#tasks + 1));
    print "$u $tasks[$i]\n";
	
    return 0;
}
exit main()

