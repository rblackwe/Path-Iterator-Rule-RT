use Test::More;
use Test::Deep;
use Data::Dumper;
use 5.010;
use strict;
use warnings;
pass;

use lib './lib';
use Path::Iterator::Rule;
use Path::Iterator::Rule::RT;

{
	my $rule = Path::Iterator::Rule->new;
	isa_ok $rule, "Path::Iterator::Rule";


	my @DIRS = qw( 
	examples/tickets 
	examples/tickets/411
	examples/tickets/411/413
	examples/tickets/413
	examples/tickets/413/411
	examples/tickets/413/a
	examples/tickets/a
	examples/tickets/a/b
	examples/tickets/a/b/c
	examples/tickets/a/b/c/413
	);


	my @dirs;

	FILE: for my $file ( $rule->all("examples/tickets") ) {
		push @dirs,$file;
	}
	cmp_deeply(\@dirs, bag(@DIRS));
}


{

	my @DIRS = qw( 
		examples/tickets/411
		examples/tickets/411/413
		examples/tickets/413
		examples/tickets/413/411
		examples/tickets/a/b/c/413
	);
	#my @DIRS = qw( );


	my @dirs;
	my $rule = Path::Iterator::Rule->new;

	isa_ok $rule, "Path::Iterator::Rule";
	$rule->TicketSQL("Created >= '100 Days ago'");

	FILE: for my $file ( $rule->all("examples/tickets") ) {
		push @dirs,$file;
	}
	cmp_deeply(\@dirs, bag(@DIRS));
}


{

	my @DIRS = qw( 
		examples/tickets/411/413
		examples/tickets/413
		examples/tickets/a/b/c/413
	);
	#my @DIRS = qw( );


	my @dirs;
	my $rule = Path::Iterator::Rule->new;

	isa_ok $rule, "Path::Iterator::Rule";
	$rule->TicketSQL("Queue='General'");

	FILE: for my $file ( $rule->all("examples/tickets") ) {
		push @dirs,$file;
	}
	cmp_deeply(\@dirs, bag(@DIRS));
}
pass;
done_testing;
exit;

#die "Usage: $0 DIRs" if not @ARGV;

=head 

$rule->and(
	$rule->new->status("new"),
	$rule->new->owner("Nobody"),
	#$rule->new->status("open"),
);

=cut
#$rule->owner("Nobody");
#$rule->TicketSQL("Queue='Digital Ocean'");
__END__
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

