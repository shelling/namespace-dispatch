use Modern::Perl;
use Test::More;
use Try::Tiny;

use Namespace::Dispatch;

use lib qw(t/lib);

use Foo;

is_deeply (
    Foo->leaves,
    [qw(add del help modify)],
    "Foo has two submodules Add and Del",
);

is (
    Foo->dispatch(qw(add)),
    "Foo::Add",
    "request Foo to find submodule Add and return Namespace",
);

is (
    Foo->dispatch(qw(del)),
    "Foo::Del",
    "request Foo to find submodule Del and return Namespace",
);

is_deeply (
    Foo::Add->leaves,
    [qw(user)],
    "Foo::Add has submodule User",
);

is_deeply (
    Foo::Del->leaves,
    [],
    "Foo::Del has no submodule",
);

is (
    Foo::Add->has_leaf("user"),
    "Foo::Add::User",
    "",
);

is (
    Foo::Del->has_leaf("user"),
    0,
    "",
);

is (
    Foo->dispatch(qw(add user hello)),
    "Foo::Add::User::Hello",
    "Foo can do recursive dispatch",
);

is (
    Foo::Add->dispatch(qw(user hello)),
    "Foo::Add::User::Hello",
    "Any node can alsod do recursive dispatch",
);

is_deeply (
    Foo::Add::User->leaves,
    [qw(hello)],
    "Foo::Add::User has one submodule Hello",
);

try {
    Foo->dispatch(qw(modify));
} catch {
    my $e = shift;
    like (
        $e,
        qr{Foo/Modify.pm did not return a true value},
        "should die when having \$@.",
    );
};

try {
    Foo->dispatch(qw(help));
} catch {
    my $e = shift;
    like (
        $e,
        qr{Foo::Help is not set up yet },
        ""
    );
};

done_testing;
