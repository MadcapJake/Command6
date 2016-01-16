# Command6

An implementation of @raganwald's [First Class Commands](https://github.com/raganwald/presentations/blob/master/command-pattern.md) presentation in Perl 6.

```perl6
my $buffer = Command::Buffer.new(
    text => 'The quick brown fox jumped over the lazy dog'
);
$buffer.replace-with('fast', 4, 9);
#-> The fast brown fox jumped over the lazy dog
$buffer.undo();
#-> The quick brown fox jumped over the lazy dog
$buffer.replace-with('My', 0, 3);
#-> My quick brown fox jumped over the lazy dog
$buffer.redo();
#-> My fast brown fox jumped over the lazy dog
```
