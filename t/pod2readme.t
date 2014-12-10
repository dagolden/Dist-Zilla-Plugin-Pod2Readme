use 5.008;
use strict;
use warnings;
use Test::More 0.96;

use Test::DZil;

my $root = 'corpus/DZ';

{
    my $tzil = Builder->from_config( { dist_root => 'corpus/DZT' },
        { add_files => { 'source/dist.ini' => simple_ini(qw/GatherDir Pod2Readme/) } } );

    ok( $tzil, "created test dist" );

    $tzil->build;

    my $contents = $tzil->slurp_file('build/README');

    like( $contents, qr{DZT::Sample}, "dist name appears in README", );

    like( $contents, qr{Foo the foo}, "description appears in README" );
}

done_testing;
# COPYRIGHT
