# Wiki

```text
usage: wiki [term] [-hblwc]
aliases:
 [ -h, --help ], show current help message
 [ -b, --briefs ], show brief description of first few matching results
 [ -l, --links ], show [x] wikipedia links matching input term
 [ -w, --write ], write the term search result to an html file
 [ -c, --locale ], the locale used to fetch the term from wikimedia
```

## Usage
```bash
wiki ww2 # [= wiki ww2 -b] returns short text explaining the term "ww2"
wiki "pearl jam" -l 3 # returns 3 wikipedia links related to the term "pearl jam"
wiki cleopatra -w # writes and html file named "cleopatra" inside a folder named "wikidocs" on the current directory
wiki "donald trump" -c fr -l 2 # returns 2 wikipedia links in french related to "donald trump"
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
