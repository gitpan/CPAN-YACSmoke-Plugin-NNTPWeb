use Test::More tests => 7;

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
    nntp_id => 187380
};

{
    # specify the start point
    my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($self);
    isa_ok($plugin,'CPAN::YACSmoke::Plugin::NNTPWeb');
    my @list = $plugin->download_list();
    cmp_ok(@list, 'gt', 0);
}

{
    # use default start point
    my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new();
    my @list = $plugin->download_list();
    cmp_ok(@list, 'eq', 0);
}

{
    my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($self);
    $plugin->_put_storage(1234);
    is($plugin->_get_storage(),1234);
    $plugin->_put_storage(123456);
    is($plugin->_get_storage(),123456);
}

{
    # make a test run
    my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($self);
    my @list = $plugin->download_list(1);
    cmp_ok(@list, 'gt', 0);
    is($plugin->_get_storage(),187479);
}
