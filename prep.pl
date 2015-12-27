
use strict;
use warnings;

use File::Slurp;

my $sFnameIANA = shift;
# print STDERR " DDD arg1(iana)=$sFnameIANA\n";
my $sFnamePM = shift;
# print STDERR " DDD arg2(pm)=$sFnamePM\n";

my $sIANA = read_file($sFnameIANA) || die;
my $sPM   = read_file($sFnamePM) || die;

$sPM =~ s/IIIIIIIIII/$sIANA/;

write_file($sFnamePM, $sPM) || die;

__END__
