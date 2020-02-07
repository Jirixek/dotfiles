(** User Mathematica initialization file **)

(** "Wolfram Mathematica" directory removal **)
With[{dir = $HomeDirectory <> "/Wolfram Mathematica"},
  If[DirectoryQ[dir], DeleteDirectory[dir]]
]

