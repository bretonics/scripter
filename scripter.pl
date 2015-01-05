#!/usr/bin/perl 

use warnings;
use strict;
use diagnostics;
use feature qw(say);
use Getopt::Std;

#####################
#   Automate coding files with default content
#
# 	Created by: Andres Breton
#	File:       scripter.pl ©
#
#####################

#####################
# CHECKS

checkARGV(@ARGV);


#####################
# VARIABLES
my $fileName = $ARGV[0];
chomp $fileName;
my $mode = 0755;

my @fileExtensions = qw(pl rb py c);    #File extensions available to write. Add extensions here and template for extension in sub "touchFile"

#####################
# CALLS
searchFile($fileName);


#####################
# SUBS

sub checkARGV {
    my @arguments = @_;
    my $numberARGV =  $#ARGV +1;
    unless (@ARGV >= 1) {
        say "You did not provide the right number of arguments";
        say "Please provide your file name";
        exit;
    }
    
}

sub searchFile {
    my ($fileName) = @_;
    my ($file) = $fileName =~ /.(\w+$)/;        #get file extension
    foreach my $fileType (@fileExtensions) {    #search for file type in @fileType
        if ($fileType eq $file) {
            touchFile($fileType, $fileName);    #make file
            exit;
        }
    }
    say "You did not provide a proper file type. File extension provided was \"$file\"\n";
    say "Valid extension include:";
    print join("\n",@fileExtensions), "\n\n";
}

sub touchFile   {               #file maker
    my ($fileType, $fileName) = @_;
    my ($name) = $fileName =~ /(\w+).$fileType/;
    my $user = $ENV{LOGNAME};
    
    unless (open(OUTFILE, ">", $fileName)) {     #check out file write access
        say "Unable to write file. Please check permissions";
        die "Can not open $fileName for writing.\n", $!;
    }
    
    if ($fileType eq "pl") {    #perl file
        print OUTFILE "#!/usr/bin/perl \n\nuse warnings;\nuse strict;\nuse diagnostics;\nuse feature qw(say);\n\n#####################\n#\n# 	Created by: $user \n#	File: $fileName\n#\n#####################\n\n";     #perl file content
        say "File $fileName created successfully.";
        perms($fileName);
    }
    
    if ($fileType eq "rb") {    #ruby file
        print OUTFILE "#!/usr/bin/ruby\n\n#####################\n#\n# 	Created by: $user \n#	File: $fileName\n#\n#####################\n\n";     #ruby file content
        say "File $fileName created successfully.";
        perms($fileName);
    }
    
    if ($fileType eq "py") {    #python file
        print OUTFILE "#!/usr/bin/python\n\nimport sys\n\n#####################\n#\n# 	Created by: $user\n#	File: $fileName\n#\n#####################\n\n";     #python file content
        say "File $fileName created successfully.";
        perms($fileName);
    }
    
    if ($fileType eq "c") {     #c file
        print OUTFILE "//\n//  $fileName\n//\n//\n//  Created by $user \n//\n//\n#include <stdio.h>\n#include <stdlib.h>\n\n#include <string.h>\n\nint main(){\n\n}";       #c file content
        say "File $fileName created successfully.";
        perms($fileName);
    }
}

sub perms {
    my ($fileName)= @_;
    chmod $mode, $fileName;
    system("open $fileName");
}
