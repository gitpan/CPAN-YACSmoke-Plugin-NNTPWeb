use Test::More tests => 7;

eval "use WWW::Mechanize";
plan skip_all => "WWW::Mechanize required for testing NNTPWeb plugin" if $@;
eval "use Template::Extract";
plan skip_all => "Template::Extract required for testing NNTPWeb plugin" if $@;


use CPAN::YACSmoke;
use CPAN::YACSmoke::Plugin::NNTPWeb;
use CPANPLUS::Configure;

my $conf = CPANPLUS::Configure->new();
my $smoke = { conf => $conf };
bless $smoke, 'CPAN::YACSmoke';

unlink './cpansmoke.store';
$smoke->basedir('.');

my $conf1 = { smoke => $smoke, limit => 10, nntp_id => 20 };
my $conf2 = { smoke => $smoke, limit => 10 };

SKIP: {
	skip "Can't see a network connection", 7   if(pingtest());

    {
        # specify the start point
        my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($conf1);
        isa_ok($plugin,'CPAN::YACSmoke::Plugin::NNTPWeb');
        my @list = $plugin->download_list();
        cmp_ok(@list, 'eq', 10);
    }

    {
        # use default start point (should use last from above)
        my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($conf2);
        my @list = $plugin->download_list();
        cmp_ok(@list, 'eq', 10);
    }

    {
        my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($conf1);
        $plugin->_put_storage(1234);
        is($plugin->_get_storage(),1234);
        $plugin->_put_storage(123456);
        is($plugin->_get_storage(),123456);
    }

    {
        # make a test run
        my $plugin = CPAN::YACSmoke::Plugin::NNTPWeb->new($conf1);
        my @list = $plugin->download_list(1);
        cmp_ok(@list, 'eq', 10);
        cmp_ok($plugin->_get_storage(), 'eq', 40);
    }
}

###########################################################

# crude, but it'll hopefully do ;)
sub pingtest {
  system("ping -q -c 1 www.google.com >/dev/null 2>&1");
  my $retcode = $? >> 8;
  # ping returns 1 if unable to connect
  return $retcode;
}
