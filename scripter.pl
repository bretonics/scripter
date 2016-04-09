#!/usr/bin/env perl

use warnings; use strict; use diagnostics; use feature qw(say);
use Getopt::Long; use Pod::Usage;

use FindBin; use lib "$FindBin::RealBin/lib";

use Content;

# =============================================================================
#   CAPITAN: Andres Breton
#   FILE: scripter.pl
#   LICENSE: GPL2
#   USAGE: Automate file creation with default content/structure
#
# =============================================================================


#-------------------------------| COMMAND LINE |-------------------------------#
my $DESCRIPTION = "";
my $LICENSE = ""; #default license
my $TYPE = ""; #default for special script types, i.e.) modules
my $usage= "\n\n $0 [options]\n
Options:
    -description    File description
    -license        License
    -type           Special file type
        Module: -type module

    -help   Shows this message
\n";


# OPTIONS
GetOptions(
    'd:s'   => \$DESCRIPTION,   #script description?
    'l:s'   => \$LICENSE,       #license? MIT, GPL, Apache...
    't:s'   => \$TYPE,          #special type
    help    => sub{pod2usage($usage);}
)or pod2usage(2);

# CHECKS
checkARGV(@ARGV);

#-------------------------------| VARIBALES |-------------------------------#
my $REALBIN = "$FindBin::RealBin";
my $perms = 0755; #what default file permissions do you want?
my $USER = "Andres Breton"; #or $ENV{LOGNAME}

my @fileExtensions = qw(pl pm py r rb c);    #File extensions available to write. Add extensions here and template for extension in sub "touchFile"
my %templates = (pl=>"perl",pm=>"perl",py=>"python",
                r=>"r",rb=>"ruby",c=>"c"); #extension -> template file hash

# Color Output...looking nice
my $GREEN = "\e[1;32m";
my $RED = "\e[1;31m";
my $NC = "\e[0m";

#-------------------------------| CALLS |-------------------------------#
foreach my $fileName (@ARGV) {
    newFile($fileName);
}

#-------------------------------| SUBS |-------------------------------#
sub checkARGV {
    my @arguments = @_;
    my $numberARGV =  $#ARGV +1;
    unless (@ARGV >= 1) {
        say "You did not provide the right number of arguments";
        say "Please provide your file name", $!;
        exit;
    }
}

sub newFile {
    my ($fileName) = @_;
    my ($ext) = $fileName =~ /.(\w+$)/;        #get file extension
    foreach my $extension (@fileExtensions) {    #search for file type in @fileExtensions
        if ($extension eq $ext) {
            if(-e $fileName) {                  #check file exists. Do NOT overide
                say "$fileName ${RED}not${NC} created, file already exists.\nTerminating...", $!;
                last;
            } else {
                touchFile($fileName,$extension);    #make file
                last;
            }
        }
    }
    say "You did not provide a proper file type. File extension provided was \"$ext\"\n";
    say "Valid extensions are:";
    print join(",",@fileExtensions), "\n\n";
}

sub touchFile   {               #file maker
    my ($fileName,$extension) = @_;
    my ($name) = $fileName =~ /(\w+).$extension/;

    unless (open(OUTFILE, ">", $fileName)) {     #check out file write access
        say "Unable to write file. Please check permissions";
        die "Can not open $fileName for writing.\n", $!;
    }

    # Search for template file matching extension provided
    foreach my $key (%templates) {
        if ($key eq $extension) {
            my $template = $templates{$extension}; #get template of file desired
            my $returnVal = writeContent($fileName, $USER, $LICENSE, $REALBIN, $template, \*OUTFILE);
            fileSuccess($fileName);
            last;
        }
    } close OUTFILE;
}

sub fileSuccess {
    my ($fileName)= @_;
    chmod $perms, $fileName; #change file permissions
    say "$fileName created ${GREEN}successfully${NC} \nOpening file...";
    my $openFile = exec("open", "$fileName")
}
