package CPAN::YACSmoke::Plugin::NNTPWeb;

use strict;

our $VERSION = '0.05';

# -------------------------------------

=head1 NAME

CPAN::YACSmoke::Plugin::NNTPWeb - NNTP web plugin for CPAN::YACSmoke

=head1 SYNOPSIS

  use CPAN::YACSmoke;
  my $config = {
      list_from => 'NNTPWeb',
      nntp_id => 180500       # NNTP id to start from (*)
  };
  my $foo = CPAN::YACSmoke->new(config => $config);
  my @list = $foo->download_list($testrun);

  # (*) defaults to the last id it saw.

=head1 DESCRIPTION

This module provides the backend ability to access the list of current
modules, as posted by PAUSE via the NNTP service, and can be seen on the
webpage at http://www.nntp.perl.org/group/perl.cpan.testers/.

This module should be use together with CPAN::YACSmoke.

=cut

# -------------------------------------
# Library Modules

use lib qw(./lib);

use WWW::Mechanize;
use Template::Extract;
use Storable;
use File::Basename;
use File::Path;

# -------------------------------------
# Constants

use constant	STORAGE	=> '/cpansmoke.store';
use constant    NNTP    => 'http://www.nntp.perl.org/group/perl.cpan.testers';
use constant    LIMIT   => 100;

# -------------------------------------
# Variables

my $mechanize = WWW::Mechanize->new();
my $extract   = Template::Extract->new();

my $last_key = 0;

my $template = q![% FOREACH data %]<tr>
<td class="list">[% counter %]</td>
<td class="list">[% subject %]</td>
<td class="list">[% poster %]</td>
<td class="list">[% timestamp %]</td>[% ... %]</tr>[% END %]!;

# -------------------------------------
# The Subs

=head1 CONSTRUCTOR

=over 4

=item new()

Creates the plugin object.

=back

=cut
    
sub new {
    my $class = shift;
    my $hash  = shift;

    my $self = {};
    foreach my $field (qw( smoke nntp_id )) {
        $self->{$field} = $hash->{$field}   if(exists $hash->{$field});
    }

    bless $self, $class;
}

=head1 METHODS

=over 4

=item download_list($testrun)

Download the list of distributions uploaded since the last stored 'nntp_id'.
If $testrun is set, the old value is retained, rather than resetting with the
latest id.

=cut
    
sub download_list {
    my $self    = shift;
	my $liverun = shift || 0;
    my @modules;

    return ()   unless($self->{smoke});
    my $cutoff = $self->{nntp_id} || $self->_get_storage();

    my $start = $cutoff - 1;
    my $stop  = $start + LIMIT;

    while ($start < $stop) {
        $mechanize->get( NNTP . "/$start" );
        return @modules unless($mechanize->success());

        my $content = $mechanize->content();
        if($content =~ /CPAN Upload: ([^\s]+)/is) {
            push @modules, $1;
        }
        $start++;
    };

    $self->_put_storage($start)	if($liverun);

    return @modules;
}

sub _get_storage {
    my $self  = shift;
    my $store = $self->{smoke}->basedir() . STORAGE;
    my $smoke = retrieve($store)    if(-r $store);

    return 1    unless($smoke);
    return $smoke->{nntp_id};
}

sub _put_storage {
    my $self  = shift;
    my $nntp  = shift;
    my $store = $self->{smoke}->basedir() . STORAGE;
    my $smoke = {};

    # make the directory if this is a new file
    if(!-f $store) { mkpath(dirname($store)); }

    $smoke = retrieve($store)   if(-r $store);
    $smoke->{nntp_id} = $nntp;
    store $smoke, $store;
}

1;
__END__

=pod

=back

=head1 CAVEATS

This is a proto-type release. Use with caution and supervision.

The current version has a very primitive interface and limited
functionality.  Future versions may have a lot of options.

There is always a risk associated with automatically downloading and
testing code from CPAN, which could turn out to be malicious or
severely buggy.  Do not run this on a critical machine.

This module uses the backend of CPANPLUS to do most of the work, so is
subject to any bugs of CPANPLUS.

=head1 SUPPORT

There are no known bugs at the time of this release. However, if you spot a
bug or are experiencing difficulties that are not explained within the POD
documentation, please submit a bug to the RT system (see link below). However,
it would help greatly if you are able to pinpoint problems or even supply a 
patch. 

Fixes are dependant upon their severity and my availablity. Should a fix not
be forthcoming, please feel free to (politely) remind me by sending an email
to barbie@cpan.org .

RT: http://rt.cpan.org/Public/Dist/Display.html?Name=CPAN-YACSmoke-Plugin-NNTPWeb

=head1 SEE ALSO

The CPAN Testers Website at L<http://testers.cpan.org> has information
about the CPAN Testing Service.

For additional information, see the documentation for these modules:

  CPANPLUS
  Test::Reporter
  CPAN::YACSmoke

=head1 DSLIP

  b - Beta testing
  d - Developer
  p - Perl-only
  O - Object oriented
  p - Standard-Perl: user may choose between GPL and Artistic

=head1 AUTHOR

Barbie <barbie@cpan.org>
for Miss Barbell Productions http://www.missbarbell.co.uk.

=head1 COPYRIGHT AND LICENSE

  Copyright (C) 2005-2007 Barbie for Miss Barbell Productions.

  This library is free software; you can redistribute it and/or 
  modify it under the same terms as Perl itself.

The full text of the licenses can be found in the Artistic file included with
this distribution, or in perlartistic file available with your Perl 
installation.

=cut