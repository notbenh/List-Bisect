package List::Bisect;
use strict;
use warnings;
use Exporter qw{import};
our @EXPORT = qw{bisect trisect};

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

=head2 trisect

  my ($a,$b,$c) = trisect {$_ <=> 5} 1..10;
  # $a == [1..4]
  # $b == [5]
  # $c == [6..10]

Useage is like grep where you pass it a block and a list, returns a list of three arrayrefs. The
intent here though is to break that list in to three parts using cmp-style returns (-1/0/1). All
values that cause your codeblock to return -1 are in the first arrayref, 0 in the next, and
everything else falls in the last arrayref.

B<!!NOTE!!> Currently the last arrayref is a catch all for anything that does not exactly match
-1/0.  If you write your own cusom block that returns any value other then -1/0/1 then it will
end up here. This was done as I want to keep the expectation that all items from the input list
will be found some where in the output.

  my ($x,$y,$z) = trisect { $_ < 5 ? -1
                          : $_ > 5 ? 1
                          : 'foo'
                          } 1..10;
  # $x == [1..4]
  # $y == []
  # $z == [5..10]

=cut

sub trisect (&@) {
   require Scalar::Util;
   my $cmp = shift;

   my @lt;
   my @eq;
   my @gt;
   foreach $_ (@_) {
      my $val = &$cmp;
      if (Scalar::Util::looks_like_number($val) ) {
         if ($val == -1) {
            push @lt, $_;
         }
         elsif ($val == 0) {
            push @eq, $_;
         }
         else {
            push @gt, $_;
         }
      }
      else {
         push @gt, $_;
      }
   }

   return (\@lt,\@eq,\@gt);
}




1;
