package Content;

use warnings; use strict; use feature qw(say);

use Exporter qw(import);
our @ISA = qw(Exporter);
our @EXPORT = qw(writeContent license); #functions exported by default
our @EXPORT_OK = qw(); #functions exported on demand

# ==============================================================================
#
#   CAPITAN: Andres Breton
#   FILE: Content.pm
#   USAGE: Get/write content from template files
#
# ==============================================================================

sub writeContent {
    my ($fileName, $USER, $LICENSE, $REALBIN, $template, $OUTFILE) = @_;
    my $tempFile = "$REALBIN/templates/$template";
    open(my $tempFileFH, $tempFile) or die "Could not find template file $tempFile", $!;
    while(<$tempFileFH>){
        if ($_ =~ /^#\s+CAPITAN:/) {
            chomp $_;
            print $OUTFILE "$_ $USER\n"; next;
        }
        if ($_ =~ /^#\s+FILE:/) {
            chomp $_;
            $0 =~ /.*\/(.+)/;
            print $OUTFILE "$_ $fileName\n"; next;
        }
        if ($_ =~ /^#\s+LICENSE:/) {
            chomp $_;
            print $OUTFILE "$_ $LICENSE\n"; next;
        }
        print $OUTFILE $_;
    }
    close $tempFileFH;
}

sub license {


}



1; #return true value
