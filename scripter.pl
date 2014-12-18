#!/usr/bin/perl 

use warnings;
use strict;
use diagnostics;
use feature qw(say);

#####################
#   Automate coding files with default content
#
# 	Created by: Andres Breton
#	File:   scripter.pl
#
#####################

#####################
# VARIABLES
my $fileName = $ARGV[0];
chomp $fileName;

my @fileTypes = qw(pl ruby c python);

#####################
# CALLS
searchFile($fileName);


#####################
# SUBROUTINES
sub searchFile {
    my ($fileName) = @_;
    my ($file) = $fileName =~ /.(\w+$)/;    #search file extension
    foreach my $fileType (@fileTypes) {     #search for file type in @fileType
        if ($fileType eq $file) {
            touchFile($fileType, $fileName);           #make file
        }
    }
}

sub touchFile   {
    my ($fileType, $fileName) = @_;
    my $outFile = $fileName;
    my ($name) = $fileName =~ /(\w+).$fileType/;
    my $user = $ENV{LOGNAME};
    
    unless (open(OUTFILE, ">", $outFile)) {             #check new file able to write
        say "Unable to write file. Please check permissions";
        die "Can not open $outFile for writing.\n", $!;
    }
    
    if ($fileType eq "pl") {
        print OUTFILE "#!/usr/bin/perl \n\nuse warnings;\nuse strict;\nuse diagnostics;\nuse feature qw(say);\n\n#####################\n#\n# 	Created by: $user \n#	File: $fileName\n#\n#####################\n\n";
        say "File created successfully.";
    }
}


#say "You did not provide a proper file type. Valid extenstion include:";
#print join("\n",@fileTypes), "\n";
