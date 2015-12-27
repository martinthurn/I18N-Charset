
# $Id: Makefile.PL,v 1.20 2013-01-14 03:59:13 Martin Exp $

use inc::Module::Install;

my $sFnamePM = q{lib/I18N/Charset.pm};
all_from($sFnamePM);

requires( perl => '5.005' );
recommends('App::Info::Lib::Iconv');
recommends('Encode');
test_requires('IO::Capture::Stderr' => 0);
recommends('Jcode');
recommends('Unicode::Map');
recommends('Unicode::Map8');
recommends('Unicode::MapUTF8');
# Test::More is needed for `make test`:
test_requires('Test::More');
recommends('Test::Pod');
recommends('Test::Pod::Coverage');

sub MY::postamble
  {
  my $ret = <<'PART0';
coverage :
	$(MAKE) HARNESS_PERL_SWITCHES=-MDevel::Cover coverage_slave
coverage_slave : test
	cover
PART0
  my $sFnameIANA = q{IANA-docs/character-sets};
  if (-f $sFnameIANA)
    {
    # This must be the author's environment
    $ret .= <<"PART1";

CHARSETPM = $sFnamePM
IANA = $sFnameIANA

prep : \$(CHARSETPM)
\$(CHARSETPM) : \$(IANA)
	\$(FULLPERL) prep.pl \$(IANA) \$@
PART1
    } # if
  return $ret;
  } # MY::postamble

use Env;
if ($ENV{MTHURN_PERL_DEV})
  {
  warn "DDD This is author's development environment\n";
  use_ptar();
  } # if

WriteAll;

use Env;
if (0 && $ENV{MTHURN_PERL_DEV})
  {
  print "DDD This is author's development environment\n";
  my $sFnameMakefile = q{Makefile};
  eval "use File::Slurp";
  my $s = read_file($sFnameMakefile);
  if ($s !~ s/(DIRFILESEP\s*=\s*).+$/$1\//m)
    {
    print " EEE did not find DIRFILESEP in Makefile\n";
    } # if
  if ($s !~ s/(pm_to_blib\(){{\@ARGV}}/$1 . '{@ARGV}'/e)
    {
    print " EEE did not find pm_to_blib@ARGV in Makefile\n";
    } # if
  if ($s !~ s/(from_to\s+=>\s+){{\@ARGV}}/$1 . '{@ARGV}'/e)
    {
    print " EEE did not find from_to@ARGV in Makefile\n";
    } # if
  write_file($sFnameMakefile, $s);
  } # if

__END__

