#!/usr/bin/env perl

use strict;
use warnings;
use GD;
use DateTime;

my $message = $ARGV[0] or die "usage $0 'Message'\n";

my $im = new GD::Image(52,7);

my $black = $im->colorAllocate(0,0,0); 
my $white = $im->colorAllocate(255,255,255); 

$im->filledRectangle(0,0,52,100,$white);

$im->string(GD::Font->Tiny,1,-1,$message, $black);

my $date = DateTime->now->add(years => -1);
# Find first sunday
until ($date->day_of_week == 7) { $date->add( days => 1 ) }

for my $x (0..51) {
  for my $y (0..6) {
    # Color index 0 is black
    # Color index 1 is white
    my $num = $im->getPixel($x, $y);
    printf "%3d %3d %3d on (%d,%d) %s\n", $im->rgb($num), $x, $y, $date->ymd;
    git_commit($date, $num);
    $date->add(days => 1);
  }
}

#open my $f, '>', 'image.png';
#print $f $im->png;
#close $f;

sub git_commit {
  my ($date, $num_commits) = @_;

  return if ($num_commits == 0);
  `touch file-$date`;
  `git add file-$date`;
  `git commit --date $date --message 'Commit for $date'`;
}


