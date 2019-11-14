#!perl
# Function: Transform the Rgi result to a dataframe.
# Author: eternal-bug
# First edit: 2019-11-07
# Last  edit: 2019-11-14

use strict;
use warnings;
use File::Find::Rule;
use File::Basename;
use Getopt::Long;

my $arguments = GetOptions(
    "i|input=s"     =>\( my $input ),
    "o|output:s"    =>\( my $output),
    "contain_all"   =>\( my $contain_all ), 
    "h|help"        =>\( my $help ),
);

sub usage {
    my $help = "
    
    perl $0 -i [PATH] -o [OUTPUT] ( --contain_all )
    
    -i|--input      the rgi result( .txt file path )
    
    -o|--output     the output file.
    
    --contain_all   contain all samples even if which's count of all gene are 0.
    
    --help
    
";
    return $help;
}

die usage() if $help;

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
    
    if( not exists $hash{$prefix} and defined $contain_all ){
        $hash{$prefix} = {};
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
