use inc::Module::Install;

name          'Namespace-Dispatch';
all_from      'lib/Namespace/Dispatch.pm';
author        'shelling <navyblueshellingford@gmail.com>';
license       'MIT';
perl_version  '5.010';


requires      'UNIVERSAL::filename';

tests         't/*.t';
author_tests  'xt';

test_requires 'Test::More';

auto_set_repository;
auto_include;
WriteAll;
