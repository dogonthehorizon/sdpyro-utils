#!/usr/bin/perl -w

use strict;

# If we don't have two arguments, then chances are we don't have the files
# we need to make this script work.
die &usage unless $#ARGV+1 == 2;

# Get command line arguments.
my $plugin_input = shift;
my $plugin_data  = shift;

# Attempt to open our two data files.
open INPUT_FILE, $plugin_input or die "Could not open $plugin_input.\n";
open DATA_FILE, $plugin_data or die "Could not open $plugin_data.\n";

# Load our input file into a hash that we can reference later.
# Keys will be the plugin name and the value will be the version.
my %plugin_input_hash;
while(<INPUT_FILE>){
    # Ignore the first line of the file, since it only contains the date.
    next if $. == 1;

    chomp;
    my ($key, $val) = split /\:/;
    $plugin_input_hash{$key} = $val;
}

# Load our data file into a hash that we can reference later.
# Keys will be the plugin name and values will be the url of the plugin.
my %plugin_data_hash;
while(<DATA_FILE>){

    chomp;

    my ($key,$val) = split /,/;
    $plugin_data_hash{$key} = $val;
}

foreach my $plugin ( keys %plugin_input_hash){
    my $url = "Unknown" unless exists $plugin_data_hash{$plugin};
    printf "%s \t %s \t %s\n", $plugin, $plugin_input_hash{$plugin}, $url;
}

# We've thrown this into a subprogram just in case we decide to extend the
# functionality of our script later.
sub usage() {
    print <<USAGE
    Usage: $0 INPUT_FILE INPUT_DATA
USAGE
}
