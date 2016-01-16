class Command::Buffer {
  use Command::Edit;

  has Str $.text is rw;
  has @!history;
  has @!future;
  submethod BUILD (:$!text = "") {}

  method replace-with ($replacement, $from = 0, $to = $!text.chars) {
    my $do = Command::Edit.new(
      :buffer(self),
      :$replacement,
      :$from, :$to
    );
    my $undo = $do.reversed;

    @!history.push($undo);
    @!future = @!future.map: sub ($edit) { $edit.prepended-with: $do }
    $do();
  }

  method undo {
    my $undo = @!history.pop;
    my $redo = $undo.reversed;

    @!future.unshift($redo);
    $undo();
  }

  method redo {
    my $redo = @!future.shift;
    my $undo = $redo.reversed;

    @!history.push($undo);
    $redo();
  }
}
