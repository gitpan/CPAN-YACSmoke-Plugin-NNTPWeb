# Note: this file was auto-generated by Module::Build::Compat version 0.03
use ExtUtils::MakeMaker;
WriteMakefile
(
    'NAME' => 'CPAN::YACSmoke::Plugin::NNTPWeb',
    'VERSION_FROM' => 'lib/CPAN/YACSmoke/Plugin/NNTPWeb.pm',
    'PREREQ_PM' => {
                'Test::More'            => 0,
                'CPAN::YACSmoke'        => '0.02_03',
                'WWW::Mechanize'        => 0,
				'Template::Extract'     => 0,
				'Storable'              => 0,
    },
    'INSTALLDIRS' => 'site',
);