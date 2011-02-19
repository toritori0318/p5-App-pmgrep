use inc::Module::Install;
name 'App-pmgrep';
all_from 'lib/App/pmgrep.pm';

requires 'App::Ack';
requires 'CPAN::DistnameInfo';
requires 'autodie';
requires 'File::Temp';
requires 'Module::Info::File';
requires 'Term::ANSIColor';

install_script 'bin/pm-grep';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
WriteAll;
