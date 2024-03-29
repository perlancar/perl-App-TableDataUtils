package App::TableDataUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{gen_rand_hash} = {
    v => 1.1,
    summary => 'Generate hash with random keys/values',
    args => {
        num_keys => {
            summary => 'Number of keys',
            schema => ['int*', min=>0],
            default => 10,
            cmdline_aliases => {n=>{}},
            pos => 0,
        },
    },
};
sub gen_rand_hash {
    my %args = @_;

    my $hash = {};

    for my $i (1..$args{num_keys}) {
        my $key;
        while (1) {
            $key = join("", map {["a".."z"]->[26*rand()]} 1..8);
            last unless exists $hash->{$key};
        }
        $hash->{$key} = $i;
    }
    [200, "OK", $hash];
}

$SPEC{gen_rand_aos} = {
    v => 1.1,
    summary => 'Generate array of scalars with random values',
    args => {
        num_elems => {
            summary => 'Number of elements',
            schema => ['int*', min=>0],
            default => 10,
            cmdline_aliases => {n=>{}},
            pos => 0,
        },
    },
};
sub gen_rand_aos {
    my %args = @_;

    my $aos = [];

    for my $i (1..$args{num_elems}) {
        push @$aos, $i;
    }
    [200, "OK", $aos];
}

$SPEC{gen_rand_aoaos} = {
    v => 1.1,
    summary => 'Generate array of (array of scalars) with random values',
    args => {
        num_rows => {
            summary => 'Number of rows',
            schema => ['int*', min=>0],
            default => 10,
            cmdline_aliases => {r=>{}},
            pos => 0,
        },
        num_columns => {
            summary => 'Number of columns',
            schema => ['int*', min=>0, max=>255],
            default => 3,
            cmdline_aliases => {c=>{}},
            pos => 1,
        },
    },
};
sub gen_rand_aoaos {
    my %args = @_;

    my $aoaos = [];

    for my $i (1..$args{num_rows}) {
        my $row = [];
        for my $j (1..$args{num_columns}) {
            push @$row, ($i-1)*$args{num_columns} + $j;
        }
        push @$aoaos, $row;
    }
    [200, "OK", $aoaos];
}

$SPEC{gen_rand_aohos} = {
    v => 1.1,
    summary => 'Generate array of (hash of scalars) with random values',
    args => {
        num_rows => {
            summary => 'Number of rows',
            schema => ['int*', min=>0],
            default => 10,
            cmdline_aliases => {r=>{}},
            pos => 0,
        },
        num_columns => {
            summary => 'Number of columns',
            schema => ['int*', min=>0, max=>255],
            default => 3,
            cmdline_aliases => {c=>{}},
            pos => 1,
        },
    },
};
sub gen_rand_aohos {
    my %args = @_;

    my $aohos = [];

    my @columns;
    {
        my $gen_hash_res = gen_rand_hash(num_keys => $args{num_columns});
        @columns = keys %{ $gen_hash_res->[2] };
    }

    for my $i (1..$args{num_rows}) {
        my $row = {};
        for my $j (0..$#columns) {
            $row->{$columns[$j]} = ($i-1)*$args{num_columns} + $j;
        }
        push @$aohos, $row;
    }
    [200, "OK", $aohos];
}

$SPEC{td2csv} = {
    v => 1.1,
    summary => 'Convert table data in STDIN to CSV',
    description => <<'_',

Actually alias for `td as-csv`.

_
    args => {
    },
};
sub td2csv {
    require App::td;

    my %args = @_;

    App::td::td(action => 'as-csv');
}

1;
#ABSTRACT: Routines related to table data

=head1 DESCRIPTION

This distribution includes a few utility scripts related to table data.

#INSERT_EXECS_LIST


=head1 SEE ALSO

L<td> from L<App::td>

L<TableDef>

=cut
