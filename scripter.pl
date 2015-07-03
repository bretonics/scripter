#!/usr/bin/perl 

use warnings; use strict; use diagnostics; use feature qw(say);
use Getopt::Long; use Pod::Usage;

# =============================================
#   Automate coding files with default content
#
# 	Created by: Andres Breton
#	File:       scripter.pl ©
#
# =============================================


#-------------------------------------------------------------------------
# COMMAND LINE

my $DESCRIPTION = "";
my $LICENSE = "";
my $usage= "\n\n $0 [options]\n
Options:
    -f      File     
    -help   Shows this message
\n";


# OPTIONS
GetOptions(
    'd:s'   => \$DESCRIPTION,   #script description?
    'l:s'   => \$LICENSE,       #license? MIT, GPL, Apache...
    help    => sub{pod2usage($usage);}
)or pod2usage(2);


#-------------------------------------------------------------------------
# CHECKS

checkARGV(@ARGV);

#-------------------------------------------------------------------------
# VARIABLES

my $fileName = $ARGV[0]; chomp $fileName;
my $perms = 0755; #what default file permissions do you want?

my @fileExtensions = qw(pl py r rb c);    #File extensions available to write. Add extensions here and template for extension in sub "touchFile"
my %templates = (pl=>"perl",py=>"python",r=>"r",rb=>"ruby",c=>"c"); #extension -> template file hash

# Color Output...looking nice
my $grnTxt = "\e[1;32m";
my $redTxt = "\e[1;31m";
my $NC = "\e[0m";

#-------------------------------------------------------------------------
# CALLS

newFile($fileName);

#-------------------------------------------------------------------------
# SUBS

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
    foreach my $extension (@fileExtensions) {    #search for file type in @fileType
        if ($extension eq $ext) {
            if(-e $fileName) {                  #check file exists
                say "$fileName ${redTxt}not${NC} created, file already exists.\nTerminating...", $!;
                exit;
            }
            touchFile($fileName,$extension);    #make file
            exit;
        }
    }
    say "You did not provide a proper file type. File extension provided was \"$ext\"\n";
    say "Valid extension include:";
    print join("\n",@fileExtensions), "\n\n";
}

sub touchFile   {               #file maker
    my ($fileName, $extension) = @_;
    my ($name) = $fileName =~ /(\w+).$extension/;
    my $user = "Andres Breton"; #or $ENV{LOGNAME}
    
    unless (open(OUTFILE, ">", $fileName)) {     #check out file write access
        say "Unable to write file. Please check permissions";
        die "Can not open $fileName for writing.\n", $!;
    }
    
    # Search for template file matching extension provided 
    foreach my $key (%templates) {
        if ($key eq $extension) {
            my $template = $templates{$extension}; #get template of file desired
            system("cat templates/$template");
            print OUTFILE `cat templates/$template` unless($? != 0); #create file from template
            fileSuccess($fileName);
            last;
        }
    }
}

sub fileSuccess {
    my ($fileName)= @_;
    chmod $perms, $fileName;
    say "$fileName created ${grnTxt}successfully${NC}.\nOpening file...";
    my $openFile = exec("open", "$fileName")
}
