package List::Bisect;
use strict;
use warnings;
use Exporter qw{import};
our @EXPORT = qw{bisect};

# ABSTRACT: split a list in to two parts by way of a grep like block

=head1 EXPORTED FUNCTION

=head2 bisect

  my ($a,$b) = bisect {$_ <= 5} 1..10;
  # $a == [1..5]
  # $b == [6..10]

Useage is like grep where you pass it a block and a list, returns a list of two arrayrefs. All 
TRUE values are put in to the first arrayref, FALSE in the second arrayref.

=cut

sub bisect (&@) {
   my $grep = shift;

   my @true;
   my @false;
   foreach $_ (@_) {
      if (&$grep) {
         push @true, $_;
      }
      else {
         push @false, $_;
      }
   }

   return (\@true,\@false);
}

1;
