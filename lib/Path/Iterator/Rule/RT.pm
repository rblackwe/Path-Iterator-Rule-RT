package Path::Iterator::Rule::RT;
use strict;
use warnings;
use Path::Iterator::Rule;
use Data::Dumper;
use Error qw(:try);
use RT::Client::REST;
use RT::Client::REST::Ticket;
my ( $username, $password, $server ) = ( 'user', 'pass', 'https://rtsever' );
( $username, $password, $server ) = ( 'root', 'password', 'http://rt.permanentlybeta.net/' );
my $rt = RT::Client::REST->new(
    server  => $server,
    timeout => 30,
);
try {
    $rt->login( username => $username, password => $password );
}
catch Exception::Class::Base with {
    die "problem logging in: ", shift->message;
};

Path::Iterator::Rule->add_helper(
         "status" => sub {
	    my $status = shift;
            return sub {
                my ( $item, $basename ) = @_;
		#warn Dumper @_;
		return check_status( $basename, $status );
                #return status( $basename, $status );
              }
        }
);

#my $another value = $ticket->cf('field two');

Path::Iterator::Rule->add_helper(
	"owner" => sub {
            my $owner = shift;
		warn "$owner";
            return sub {
                my ( $item, $basename ) = @_;
		#warn Dumper @_;
		return check_owner( $basename, $owner);
                #return status( $basename, $status );
              }
        }
);


Path::Iterator::Rule->add_helper(
	"TicketSQL" => sub {
                my $TicketSQL = shift;
		#warn "$TicketSQL";
            return sub {
                my ( $item, $basename ) = @_;
		#warn Dumper @_;
		return check_ticketSQL( $basename, $TicketSQL);
                #return status( $basename, $status );
              }
        }
);



sub status {
	warn Dumper @_;
	return;
}

sub check_ticketSQL {
    my ( $id, $TicketSQL) = @_;
    return unless $id =~ m/^\d+$/;
#    warn "--$id--";
#    warn $TicketSQL;
    my $query = "id=$id AND ";
    $query .= $TicketSQL;
#    warn "->$query<-";

  my @ids = $rt->search(
    type => 'ticket',
    query => $query,
    #query => "id=413",
  );
#warn Dumper \@ids;
	return scalar @ids == 1;
}
sub check_owner {
    my ( $id, $owner) = @_;
#warn "id $id";
    return unless $id =~ m/^\d+$/;
    my $ticket;
    try {
        $ticket = RT::Client::REST::Ticket->new(
            rt => $rt,
            id => $id,
        )->retrieve;
    }
    catch Exception::Class::Base with {
        return;
    };
    #warn "a $owner " . $ticket->owner;
    return unless $ticket;
    #warn "b $owner " . $ticket->owner;
	#return 1;
    return $owner eq $ticket->owner;
}

sub check_status {
    my ( $id, $status ) = @_;
    return unless $id =~ m/^\d+$/;
    my $ticket;
    try {
        $ticket = RT::Client::REST::Ticket->new(
            rt => $rt,
            id => $id,
        )->retrieve;
    }
    catch Exception::Class::Base with {
        return;
    };
    return unless $ticket;
    return $status eq $ticket->status;
}
1;
__END__


       #"CF" => sub {
        #"Queue" => sub {
        #"TicketSQL" => sub {


1;
