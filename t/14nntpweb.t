use Test::More tests => 2;

eval "use WWW::Mechanize";
plan skip_all => "WWW::Mechanize required for testing NNTPWeb plugin" if $@;
eval "use Template::Extract";
plan skip_all => "Template::Extract required for testing NNTPWeb plugin" if $@;


use CPAN::YACSmoke;
use CPAN::YACSmoke::Plugin::NNTPWeb;
use CPANPLUS::Configure;

my $conf = CPANPLUS::Configure->new();
my $smoke = {
    conf    => $conf,
};
bless $smoke, 'CPAN::YACSmoke';

my $self  = {
    smoke   => $smoke,
    nntp_id => 180550
};

my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($self);
isa_ok($plugin,'CPAN::YACSmoke::Plugin::NNTPWeb');

my @list = $plugin->download_list();
ok(@list > 0);

