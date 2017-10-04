#!/usr/bin/perl

print "package RON\n\n";
print "// bit-separator conversions generated by $0 on\n// ".`date`."// from\n";
$commit = `git log -n 1`;
$commit =~ s/^(.*)$/\/\/ $1/gm;
print $commit . "\n";

print "\nvar PUNCT, BITS [128]int8\n\n";

while (<> =~ /^(\w+)\s+([^\s]+)\s+(.*)$/) {
    my $name = $1;
    my $seps = $2;
    my @vals = split(/\s+/, $3);

    $escseps = $seps;
    $escseps =~ s/(["\\])/\\$1/g;
    print "const ".$name."_PUNCT = \"$escseps\"\n";

    print "const (\n";
    my $i = 0;
    for my $kind (@vals) {
        my $ch = substr($seps,$i++,1);
        if ($ch eq "'" || $ch eq "\\") {
            $ch = "\\$ch"
        }
        print "\t$name"."_".$kind."_SEP = '$ch'\n";
    }
    print ")\n";

    print "const (\n";
    my $i = 0;
    for my $kind (@vals) {
        print "\t$name"."_".$kind." = $i\n";
        $i++
    }
    print ")\n";

    print "func ".lc($name)."Sep2Bits (sep byte) uint {\n";
    print "\tswitch sep {\n";
    for my $kind (@vals) {
        print "\t\tcase ".$name."_".$kind."_SEP:"."\treturn $name"."_".$kind."\n"; 
    }
    print "\t\tdefault: panic(\"invalid ".lc($name)." separator\")\n";
    print "\t}\n}\n";

    print "func ".lc($name)."Bits2Sep (bits uint) byte {\n";
    print "\tswitch bits {\n";
    for my $kind (@vals) {
        print "\t\tcase ".$name."_".$kind.":"."\treturn $name"."_".$kind."_SEP\n"; 
    }
    print "\t\tdefault: panic(\"invalid ".lc($name)." bits\")\n";
    print "\t}\n}\n";

    #print "$name $seps ".join(":", @vals) . "\n"

    print "\n\n";
}
