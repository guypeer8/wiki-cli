# Wiki

```text
usage: wiki [term] [-hblw]
aliases:
 [ -h, --help ], show current help message
 [ -b, --briefs ], show brief description of first few matching results
 [ -l, --links ], show [x] wikipedia links matching input term
 [ -w, --write ], write the term search result to an html file
```
 
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `wiki` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wiki, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/wiki](https://hexdocs.pm/wiki).
