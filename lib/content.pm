package Content;

use warnings; use strict; use feature qw(say);

use Exporter qw(import);
our @ISA = qw(Exporter);
our @EXPORT = qw(writeContent license); #functions exported by default

sub writeContent {
    my ($fileName, $USER, $LICENSE, $REALBIN, $template, $OUTFILE) = @_;
    open(SYSCALL, "cat $REALBIN/templates/$template |") or die "Could not find template file $!"; #sys call
    while(<SYSCALL>){
        # say $OUTFILE;
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
    close SYSCALL;
}

sub license {


}



1; #return true value
