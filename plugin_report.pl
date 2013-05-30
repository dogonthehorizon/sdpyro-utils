#!/usr/bin/perl -w

use strict;

# If we don't have two arguments, then chances are we don't have the files
# we need to make this script work.
die &usage unless $#ARGV+1 == 2;

# Get command line arguments.
my $plugin_text = shift;
my $plugin_data  = shift;

# Attempt to open our two data files.
open TEXT_FILE, $plugin_text or die "Could not open $plugin_text.\n";
open DATA_FILE, $plugin_data or die "Could not open $plugin_data.\n";
open OUTP_FILE, ">", "output.txt";

my %plugins;
while (<TEXT_FILE>) {
    next if $. == 1;

    chomp;
    my ($name,$version) = split /\:/;

    $plugins{$name} = $version;
}

while (<DATA_FILE>) {
    chomp;
    my @links = split /,/;
    my $name = shift @links;
    print $name."\n";
    foreach my $link (@links) {
        $plugins{$name} .= ",$link";
    }
}

foreach my $key (sort keys %plugins){
    print "$key : $plugins{$key}\n";
}

close TEXT_FILE;
close DATA_FILE;
close OUTP_FILE;

# We've thrown this into a subprogram just in case we decide to extend the
# functionality of our script later.
sub usage() {
    print <<USAGE
    Usage: $0 INPUT_FILE INPUT_DATA
USAGE
}

# Properly format an anchor and return it
sub format_url ($) {
    return "<a href=\"$_\">Download</a>";
}
