use inc::Module::Install;
name 'Script-State';
all_from 'lib/Script/State.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
