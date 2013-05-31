#!/usr/bin/perl

use strict;
use List::MoreUtils qw( each_array );

# If we don't have two arguments, then chances are we don't have the files
# we need to make this script work.
die &usage unless $#ARGV+1 == 3;

# Get command line arguments.
my $plugin_text = shift;
my $plugin_data  = shift;
my $output_file = shift;

# Check the first argument for a call to help.
if (($plugin_text eq "-h") or ($plugin_text eq "--help")) {
    die &usage;
}

# Attempt to open our two data files.
open TEXT_FILE, $plugin_text or die "Could not open $plugin_text.\n";
open DATA_FILE, $plugin_data or die "Could not open $plugin_data.\n";
open OUTP_FILE, ">", $output_file;
####################
# BEGIN PAGE HEADER
####################
# Used in our printblock
my $time = localtime();
print OUTP_FILE <<HTML
<html>
    <head>
        <base target='_blank' />
        <meta http-equiv='Content-Type' content='text/html;charset=UTF-8' />
        <style>
            body { font-family: sans-serif; }
        </style>
    </head>
    <body>
    <h3>$time</h3>
    <div id='contentBox' style='margin:0px auto; width:100%; float:left;'>
HTML
;
####################
# END PAGE HEADER
####################

# Read our data files into arrays for processing.
my @plugins;
my @plugin_links;
while(<TEXT_FILE>){
    # Skip the first result, since it just contains a date string.
    next if $. == 1;
    chomp $_;
    push @plugins, $_;
}

while(<DATA_FILE>) {
    chomp $_;
    push @plugin_links, $_;
}

# Now we can iterate over both arrays at the same time.
my $iterator = each_array @plugins, @plugin_links;
while (my ($plugin, $links) = $iterator->() ) {

    my ($name, $version) = split /:{1}/ , $plugin;
    my @link_list = split /,/ , $links;
    # The first entry of @link_link will be the plugin name, which we already
    # have, so lets just toss that value.
    shift @link_list;

    my $link_string;
    for $_ (@link_list) {
        my $url = &format_url($_);
        $link_string .= "$url ";
    }

    print OUTP_FILE <<HTML
        <div id='column1' style='float:left; margin:0; width:220;'>$name</div>
        <div id='column2' style='float:left; margin:0; width:220;'>$version</div>
        <div id='column3' style='float:left; margin:0; width:auto;'>$link_string</div><br />
HTML
}

####################
# BEGIN PAGE FOOTER
####################
print OUTP_FILE <<HTML
    </body>
</html>
HTML
;
####################
# END PAGE FOOTER
####################

close TEXT_FILE;
close DATA_FILE;
close OUTP_FILE;

##
# usage
#
# Print a usage message for the user.
##
sub usage() {
    print <<USAGE
    Usage: $0 [opts] PLUGIN_LIST PLUGIN_LINKS

        -h, --help      print this message and exit.

        PLUGIN_LIST     The list of plugins with their associated version 
                        numbers. Colon delimited.

        PLUGIN_LINKS    The list of plugins with their associated download 
                        links. Comma delimited.

        NOTE: This script assumes that BOTH FILES have the SAME NUMBER OF 
              ENTIRES. This script will not work otherwise.
USAGE
}

##
# format_url
#
# @param the url that we will be formatting
#
# @return the formatted anchor tag
##
sub format_url ($) {
    if ($_ eq "N/A") {
      return "N/A";
    }

    if ($_ eq "") {
      return "No URL / New Plugin"
    } else {
       return "<a href=\"$_\">Download</a> &nbsp; ";
    }
}
