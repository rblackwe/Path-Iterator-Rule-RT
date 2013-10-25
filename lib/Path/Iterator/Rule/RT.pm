package Path::Iterator::Rule::RT;
use Path::Iterator::Rule;
use Data::Dumper;
use Error qw(:try);
use RT::Client::REST;
use RT::Client::REST::Ticket;
my ( $username, $password, $server ) = ( 'user', 'pass', 'https://rtsever' );
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
for my $status (qw(open resolved new)) {
    Path::Iterator::Rule->add_helper(
        "status_$status" => sub {
            return sub {
                my ( $item, $basename ) = @_;
                return check_status( $basename, $status );
              }
        }
    );
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
