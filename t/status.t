use Test::More;
use Test::Deep;
use Data::Dumper;
use 5.010;
use strict;
use warnings;
use Path::Iterator::Rule;
use Path::Iterator::Rule::RT;

my $rule = Path::Iterator::Rule->new;
isa_ok $rule, "Path::Iterator::Rule";
can_ok $rule, "status";

done_testing;


