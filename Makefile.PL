use inc::Module::Install;
name 'Namespace-Dispatch';
all_from 'lib/Namespace/Dispatch.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
