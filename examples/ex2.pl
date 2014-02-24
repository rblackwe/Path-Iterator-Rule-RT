use 5.010;
use strict;
use warnings;

use lib '../lib';
use Path::Iterator::Rule;
use Path::Iterator::Rule::RT;

die "Usage: $0 DIRs" if not @ARGV;
my $rule = Path::Iterator::Rule->new;

=head 

$rule->and(
	$rule->new->status("new"),
	$rule->new->owner("Nobody"),
	#$rule->new->status("open"),
);

=cut
#$rule->owner("Nobody");
#$rule->TicketSQL("Queue='Digital Ocean'");
if(1) {
	$rule->TicketSQL("Queue='General' AND Created = 'today'");
} else {
	$rule->TicketSQL("Queue='General' AND Created = 'yesterday'");
}

#$rule->status_new;
#$rule->status_open;
#$rule->status_resolved;

#$rule->status("new");
#rule->status("open");

for my $file ( $rule->all(@ARGV) ) {
    say $file;
}
__END__
    #$rule->new->status_new(),
#    $rule->new->status_open(),
#    $rule->new->status_resolved()

