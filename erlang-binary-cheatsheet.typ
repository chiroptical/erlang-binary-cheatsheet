#import "@preview/cram-snap:0.2.2": cram-snap, theader

#set page(
  paper: "a4",
  flipped: true,
  margin: 1cm,
)
#set text(font: "JetBrains Mono", size: 10pt)

#show: cram-snap.with(
  title: [Erlang Binary Cheatsheet],
)

#table(
  columns: (auto, auto, auto),
  table.header(
   [Type],
   [Size in bits],
   [Remarks]
  ),
  [`integer`], [As many as it takes], [Default size is 8 bits],
  [`float`], [*64*|32|16], [Need to specify length if other than default: `<<A:16/float>>`],
  [`binary|bytes`], [8 per chunk], [Anything matched must be of size evenly divisible by 8 (this is the default)],
  [`bitstring|bits`], [1 per chunk], [Will always match, use as `Tail` for a list],
  [`utf8|utf16|utf32`], [8-32, 16-32, and 32], [`<<"abc"/utf8>>` is the same as `<<$a/utf8, $b/utf8, $c/utf8>>`],
  [`signed|unsigned`], [N/A], [Default is unsigned],
  [`big|little|native`], [N/A], [Endianness - `native` is resolved at load time to whatever CPU uses],
  [`unit:IntLiteral`], [N/A], [Define a custom unit of length 1..256]
)

#table(
  columns: (auto, auto),
  table.header(
   [Expression],
   [Result]
  ),
  [`<<97,98,99>>`], [`<<"abc">>` (turn off with `shell:string-s(false)`)],
  [`<<A:2/unit:6, B:1/unit:4>> = <<7, 42>>`], [A = 114, B = 10],
  [`<<A:16/float>> = <<1, 17>>`], [A = 1.627e-5],
  [`<<A/signed>> = <<255>>`], [A = -1],
  [`<<A:16/big>> = <<255, 0>>`], [A = 65280],
  [`<<A:16/litte>> = <<255, 0>>`], [A = 255],
  [`<<"pöpcörn"/utf8>>`], [TODO],
  [
    When constructing a binary, if the size of an integer `N` is too large
    to fit inside the given segment, the most signif­icant bits are silently
    discarded and only the `N` least significant bits kept.
  ]
)
