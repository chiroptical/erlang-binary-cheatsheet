#import "@preview/cram-snap:0.2.2": cram-snap, theader

#set page(paper: "a4", flipped: true, margin: 1cm

// TODO: Can we add custom fonts?
// #set text(font: "JetBrains Mono", size: 10pt)

#show: cram-snap.with(title: [Erlang Binary Cheatsheet])

#table(
  columns: (auto, auto, auto),
  table.header([Type], [Size in bits], [Remarks]),
  [`integer`], [As many as it takes], [Default size is 8 bits],
  [`float`], [*64*|32|16], [Need to specify length if other than the default 64: `<<A:16/float>>`],
  [`binary|bytes`], [8 per chunk], [Anything matched must be of size evenly divisible by 8 (this is the default)],
  [`bitstring|bits`], [1 per chunk], [Will always match, use as `Tail` for a list],
  [`utf8|utf16|utf32`], [8-32, 16-32, and 32], [`<<"abc"/utf8>>` is the same as `<<$a/utf8, $b/utf8, $c/utf8>>`],
  [`signed|unsigned`], [N/A], [Default is unsigned],
  [`big|little|native`], [N/A], [Endianness - `native` is resolved at load time to whatever CPU uses],
  [`unit:IntLiteral`], [N/A], [Define a custom unit of length 1..256]
)

#table(
  columns: (auto, auto),
  table.header([Expression], [Result]),
  [`<<97,98,99>>`], [`<<"abc">>`#super[1]],
  [`<<A:2/unit:6, B:1/unit:4>> = <<7, 42>>`], [A = 114, B = 10],
  [`<<A:16/float>> = <<1, 17>>`], [A = 1.627e-5],
  [`<<A/signed>> = <<255>>`], [A = -1],
  [`<<A:16/big>> = <<255, 0>>`], [A = 65280],
  [`<<A:16/little>> = <<255, 0>>`], [A = 255],
  [`<<"pöpcörn"/utf8>>`], [How Erlang handles Unicode],
  table.cell(
    colspan: 2,
    [When constructing a binary, if the size of an integer `N` is too large
     to fit inside the given segment, the most significant bits are silently
     discarded and the `N` least significant bits kept.],
  ),
  table.cell(
    colspan: 2,
    [#super[1] In the shell, numbers in the ASCII range are printed as ASCII (turn off with `shell:strings(false)`)],
  ),
)


#table(
  columns: (auto),
  table.header([Segments]),
  [Each segment in a binary has the following general syntax:
   `Value:Size/TypeSpecifierList`. The `Size` and `TypeSpecifier` can be
   omitted.

   `Value` is either a literal or a variable, `Size` is multiplied by the
   unit in `TypeSpecifierList`, and can be any expression that evaluates to an
   `integer`#super[2]. Think of `Size` as the number of items of the type in
   the `TypeSpecifierList`

   *Contrived example:* `X:4/little-signed-integer-unit:8` has a total size
   of `4*8 = 32` bits, and it contains a signed integer in little endian byte
   order.
  ],
  table.footer(
    [#super[2] Mostly true, see Bit Syntax Expressions in Erlang docs for complete picture.],
  ),
)

#table(
  columns: (auto),
  table.header([Binary comprehension example]),
  [Just like with lists, there is a notation for binary comprehension.
   Below is an example of how to use this to convert a 32 bit integer into a
   hex representation:
```erlang
int_as_hex(Int) ->
  IntAsBin = <<Int:32>>,
  "0x" ++ lists:flatten(
    [byte_to_hex(<<Byte>>) || <<Byte:8>> <:= IntAsBin]
  ).
byte_to_hex(<<Nibble1:4, Nibble2:4>>) ->
  [integer_to_list(Nibble1, 16), integer_to_list(Nibble2, 16))].
```
  ],
  table.footer(
    [You can mix list- and binary comprehensions; if the generator is a list, use
     `<:-`, if it's a binary, use `<:=`. If you want the result to be a binary, use
     `<<>>`, if you want a list, use `[]` around the expression.],
  ),
)

#table(
  columns: (auto),
  table.header([Troubleshooting]),
  [Use the Erlang shell to trial and error your way to a correct expression. A
   useful tool for understanding why your binaries are `badmatch`ing is `bit_size`:
```erlang
bit_size(<<1/integer>>).              % => 8
bit_size(<<<<1:1, 0:1>>/bitstring>>). % => 2
bit_size(<<1.0/float>>).              % => 64
bit_size(<<<<1, 2>>/binary>>).        % => 16
```],
  table.footer(
    [A related one is `byte_size`: \
     #raw("MinBytesToEncodeNumber = byte_size(binary:encode_unsigned(Number)).", lang: "erlang")],
  ),
)
