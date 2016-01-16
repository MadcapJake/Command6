class Command::Edit {
  has $!buffer;
  has Str $.replacement;
  has Int $.from;
  has Int $.to;
  submethod BUILD (:$!buffer, :$!replacement, :$!from, :$!to) {}

  submethod CALL-ME {
    $!buffer.text = " " x $!replacement.chars unless $!buffer.text;
    my @chars = $!buffer.text.comb[0..^$!from];
    @chars.push: $!replacement;
    @chars.append: $!buffer.text.comb[$!to..*];
    $!buffer.text = @chars.join('').trim;
  }

  method net-change { $!from - $!to + $!replacement.chars }

  method reversed {
    my $replacement = $!buffer.text.comb[$!from..^$!to].join;
    my $to = $!from + $!replacement.chars;
    Command::Edit.new(:$!buffer, :$replacement, :$!from, :$to);
  }

  method is-before (Command::Edit $other) { $other.from >= $!to }

  method prepended-with (Command::Edit $other) {
    return self if self.is-before: $other;

    my $change = $other.net-change;
    self.clone(
      from => $!from + $change,
      to   => $!to + $change
    );
  }

}
