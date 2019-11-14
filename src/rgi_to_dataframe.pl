#!perl
# Function: Transform the Rgi result to a dataframe.
# Author: eternal-bug
# First edit: 2019-11-07
# Last  edit: 2019-11-07

use strict;
use warnings;
use File::Find::Rule;
use File::Basename;
use Getopt::Long;

my $arguments = GetOptions(
    "i|input=s"     =>\( my $input ),
    "o|output:s"    =>\( my $output),
    "h|help"        =>\( my $help ),
);

# first find the rgi file
my @files = File::Find::Rule->file()->maxdepth( 1 )->name("*.txt")->in( $input );

# all gene
my %genes = (); 

# samples
my %hash = ();

print STDERR "===> Begin to read the files.\n";
# read the file and get all gene and store the data
for my $file ( @files ){
    my $bname  = File::Basename::basename($file);
    my $prefix = ( $bname =~ s/\.txt$//r );

    open my $f, "<", $file or die $!;
    my $n = 0;
    while(my $read = <$f>){
        $n++;
        chomp($read);
        # first is header
        if( $n == 1){
            next;
        }else{
            my @l = split( /\t/, $read );
            my $gene = $l[8];
            $genes{$gene}++;

            # whatever the gene have emerge serval times, the number is 1.
            $hash{$prefix}{$gene} = 1;
        }
    }

    close $f;
}

my @genes = sort { $a cmp $b } keys %genes;

my $out_fh;
if( not defined $output ){
    $out_fh = *STDOUT{IO};
}else{
    open my $write_h, ">", $output or die $!;
    $out_fh = $write_h;
}

print {$out_fh} join("\t", "samples", @genes) . "\n";
for my $s ( sort { $a cmp $b } keys %hash ){
    my @nums = map { if( exists $hash{$s}{$_} ){ 1 }else{ 0 } } @genes;
    print {$out_fh} join("\t", $s, @nums) . "\n";
}
