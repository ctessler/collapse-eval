#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $USAGE = << 'EOM';
Usage: util-sum.pl <FILE>
EOM

# False entrypoint for perl
sub main {
    my %opts = ( file => "",
		 tgtu => 0.0,
		 jitr => 5,
		 sched => "../sched/sched.dat"
    );

    GetOptions("file=s" => \$opts{file},
	       "util=f" => \$opts{tgtu},
	       "sched=s" => \$opts{sched}
	)
	or die($USAGE);
    $opts{file} = shift @ARGV;

    my %data;
    open(my $fh, '<', $opts{file}) or die ("Could not open $opts{file}\n");
    while (my $line = <$fh>) {
	chomp($line);
	if ($line =~ /^#/) {
	    next;
	}
	$line =~ s/^\s+//g;
	my ($task, $util);
	($task, $util) = split(/\s+/, $line);
	push @{$data{$util}}, $task;
    }
    close ($fh);
    my %sched;
    %sched = read_sched($opts{sched});

    printf "# NC - No Collapse, NCP - NC Preemptive, CA - Collapse Arbitrary\n";
    printf "# CB - Max Benefit, CP - Min Penalty\n";
    printf "#            SCHEDULABLE SET COUNTS\n";
    printf "#%4s %5s %5s %3s %3s %3s %3s %3s\n",
	'UTIL', 'CORES', 'TOTAL', 'NC', 'CA', 'CB', 'CP', 'NCP';
    my @utils = sort {$a <=> $b} keys %data;
    my @cores = sort {$a <=> $b} keys %{$sched{ $data{$utils[0]}[0] } };
    foreach my $u (@utils) {
	my ($sc, $sa, $sb, $sp, $scp, $tot);

	foreach my $c (@cores) {
	    $sc = $sa = $sb = $sp = $scp = $tot = 0;
	    foreach my $t (@{$data{$u}}) {
		$tot += 1;
		$sc += $sched{$t}{$c}{sc};
		$sa += $sched{$t}{$c}{sa};
		$sb += $sched{$t}{$c}{sb};
		$sp += $sched{$t}{$c}{sp};
		$scp += $sched{$t}{$c}{scp};
	    }
	    printf "%5.2f %5d %5d %3d %3d %3d %3d %3d\n",
		$u, $c, $tot, $sc, $sa, $sb, $sp, $scp;
	}
    }
	
    return 0;
}

sub read_sched {
    my $file = shift;
    open(my $fh, '<', $file) or die ("Could not open $file\n");
    
    my %rv;
    while (my $line = <$fh>) {
	if ($line =~ /^#/) {
	    next;
	}
	$line =~ s/^\s+//g;
	my ($task, $cores, $sc, $sa, $sb, $sp, $ncp);
	($task, $cores, $sc, $sa, $sb, $sp, $ncp) = split(/\s+/, $line);

	$rv{$task}{$cores}{sc} = $sc eq "yes" ? 1 : 0;
	$rv{$task}{$cores}{sa} = $sa eq "yes" ? 1 : 0;
	$rv{$task}{$cores}{sb} = $sb eq "yes" ? 1 : 0;	
	$rv{$task}{$cores}{sp} = $sp eq "yes" ? 1 : 0;
	$rv{$task}{$cores}{scp} = $ncp eq "yes" ? 1 : 0;	
    }

    close($fh);
    return %rv;
}

exit main()

