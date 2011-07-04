package App::pmgrep::util;
use strict;
use warnings;

sub command {
    my $opt = shift;
    my @cmds = ("ack");
    if( $opt->{quickfix} ){
        push @cmds, ("--with-filename", "--nogroup" , "--nocolor" , "--nopager");
    }else{
        push @cmds, ("--with-filename", "--group" , "--nopager");
    }
    push @cmds, "--ignore-case" if $opt->{ignore_case};
    return @cmds;
}

sub locate_pack {
    my $dist = shift;
    $dist =~ s!::!/!g;

    for my $lib (@INC) {
        my $packlist = "$lib/auto/$dist/.packlist";
        return $packlist if -f $packlist && -r _;
    }

    return;
}

sub fixup_packilist {
    my ($packlist) = @_;
    my @target_list;
    open my $in, "<", $packlist or die "$packlist: $!";
    while (my $file = <$in>) {
        chomp $file;
        push @target_list, $file if $file =~ m/\.pm$/;
    }
    return @target_list;
}

sub slurp {
    my $file = shift;
    open my $fh, "<", $file;
    my $data = do{ local $/; <$fh>};
    close $fh;
    return $data;
}

sub pod_skip {
    my $data = shift;
    my $pod_skip = 0;
    my $res = '';
    for my $line (split /\n/, $data) {
        if ($line =~ /^=/) {
            $pod_skip = 1;
        } elsif ($line =~ /^=cut/) {
            $pod_skip = 0;
        } elsif($pod_skip != 1) {
            $res .= $line . "\n";
        }
    }
    return $res;
}

1;
