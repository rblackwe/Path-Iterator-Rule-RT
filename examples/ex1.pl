use 5.010;
use strict;
use warnings;

use lib 'lib';
use Path::Iterator::Rule;
use Path::Iterator::Rule::RT;

die "Usage: $0 DIRs" if not @ARGV;
my $rule = Path::Iterator::Rule->new;

$rule->or(
    $rule->new->status_new(),
    $rule->new->status_open(),
    $rule->new->status_resolved()
);

#$rule->status_new;
#$rule->status_open;
#$rule->status_resolved;

for my $file ( $rule->all(@ARGV) ) {
    say $file;
}

