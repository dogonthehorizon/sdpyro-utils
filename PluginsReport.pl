#!/usr/bin/perl

###########################################################################
##
## $Id: PluginsReport.pl,v 1.135 2013/08/06 00:34:42 root Exp $
##
###########################################################################

use strict;
#use warnings;
use List::MoreUtils qw( each_array );

# If we don't have two arguments, then chances are we don't have the files
# we need to make this script work.
#die &usage unless $#ARGV+1 == 1;

# Get command line arguments.
my $plugin_text = shift;
my $plugin_data  = shift;
my $output_file = shift;

my $ID;
my $VERSION;

$ID      = '$Id: PluginsReport.pl,v 1.135 2013/08/06 00:34:42 root Exp $';
$VERSION = (split (' ', $ID))[2]; 

# Check the first argument for a call to help.
if (($plugin_text eq "-h") or ($plugin_text eq "--help")) {
    die &usage;
}

sub mysort {

   lc($a) cmp lc($b);

 }

# Attempt to open our two data files.
open TEXT_FILE, $plugin_text or die "Could not open $plugin_text.\n";
open DATA_FILE, $plugin_data or die "Could not open $plugin_data.\n";
#open OUTP_FILE, ">", $output_file;
####################
# BEGIN PAGE HEADER
####################
# Used in our printblock
my $time = localtime();
#print OUTP_FILE <<HTML
print <<HTML
<html>
  <head>
    <title>PluginsReport v$VERSION</title>
    <base target='_blank' />
    <meta http-equiv='Content-Type' content='text/html;charset=UTF-8' />
      <style>
          body { font-family: sans-serif; }
          tr:hover {background-color: #0000FF; color: #FFFFFF;}
      </style>
  </head>
  <body>
    <h3>$time</h3>
    <table id='contentBox' style='margin:0px auto; width:100%; float:left;'>
HTML
;

####################
# END PAGE HEADER
####################

# Read our data files into arrays for processing.
my %pluginName;
my %pluginVersion;
my %prodUrl;
my %devUrl;
my $link_string;

while(<TEXT_FILE>){
    chomp $_;
    my ($name, $version) = split (":",$_);
    $name =~ s/\s+$//g;
    $version =~ s/^\s+//g;

    $pluginName{$name} = $name;
    $pluginVersion{$name} = $version;

#    print "$pluginName{$name},$pluginVersion{$name}\n";
}


while(<DATA_FILE>) {
    chomp $_;
    my ($name, $url1, $url2) = split (",",$_);
    $url1 =~ s/,$//g;
    $url2 =~ s/,$//g;
    
    $prodUrl{$name} = $url1;
    $devUrl{$name} = $url2;
}

# Sort the Array & output 
foreach my $key (sort mysort keys %pluginName){ 

  my $link1;
  my $link2;

  if ((!defined $prodUrl{$key}) || ($prodUrl{$key} eq "N/A")) {
    $link1 = "N/A";
  } else {
    $link1 = "<a href='$prodUrl{$key}'>Bukkit URL</a>";
  } 

  if (defined $devUrl{$key}) {
    $link2 = ",<a href='$devUrl{$key}'>Dev URL</a>";
  }

print <<HTML
      <tr>
        <td id='column1' style='float:left; margin:0; width:220;'>$pluginName{$key}</td>
        <td id='column2' style='float:left; margin:0; width:220;'>$pluginVersion{$key}</td>
        <td id='column3' style='float:left; margin:0; width:auto;'>$link1$link2</td>
      </tr>
HTML
;
}

####################
# BEGIN PAGE FOOTER
####################
print <<HTML
    </table>
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
    Usage: $0 [opts] PLUGIN_LIST PLUGIN_LINKS OUTPUT_FILE

        -h, --help      print this message and exit.

        PLUGIN_LIST     The list of plugins with their associated version 
                        numbers. Colon delimited.

        PLUGIN_LINKS    The list of plugins with their associated download 
                        links. Comma delimited.

        OUTPUT_FILE     The file with the final html output

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



