use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;
use B::Deparse;
use FindBin;

use lib "$FindBin::Bin/01-poc-lib";

use Package::Strictures -for => { 'Example' => { 'STRICT' => 1, } };
BEGIN { use_ok('Example'); }

lives_and { is Example::slow(), 5 } 'Method using strictures execute and return values';
dies_ok { Example::slow(5) } 'Method using strictures execute validation blocks';

my $deparse = B::Deparse->new();

my $code = $deparse->coderef2text( Example->can('slow') );

unlike( $code, qr/if\s*\(\s*STRICT\s*\)\s*{/, 'Stricture constant is eliminated from code' );
like( $code, qr/die\s*['"]/, 'Stricture code is in from code' );
