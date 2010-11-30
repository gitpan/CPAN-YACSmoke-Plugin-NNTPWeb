use ExtUtils::MakeMaker;
WriteMakefile
(
    'NAME' => 'CPAN::YACSmoke::Plugin::NNTPWeb',
    'VERSION_FROM' => 'lib/CPAN/YACSmoke/Plugin/NNTPWeb.pm',
    'PREREQ_PM' => {
                'Test::More'            => 0,
                'WWW::Mechanize'        => 0,
				'Template::Extract'     => 0,
				'Storable'              => 0,
                'File::Basename'        => 0,
                'File::Path'            => 0,
   },
	NO_META			=> 1,

    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT	=> 'NNTP web plugin for CPAN::YACSmoke',
       AUTHOR	=> 'Barbie <barbie@cpan.org>') : ()),
);

print <<HERE;

  Note that testing of this distribution can take a very long time.
  Please be patient, it will get there eventually :)

HERE
