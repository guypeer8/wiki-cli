defmodule Wiki.CLI do
  @strict [help: :boolean, briefs: :boolean, links: :integer, write: :boolean]
  @aliases [h: :help, b: :briefs, l: :links, w: :write]
  @description %{
    h: "show this help message",
    b: "show brief description of first matching results",
    l: "show [x] wikipedia links matching input term",
    w: "write the term search result to an html file"
  }

  def main(args \\ []) do
    {flags, names, invalid} = parse(args)

    cond do 
      tuple_contains?(flags, :help) -> show_help()
      args_valid?(names, invalid) -> Wiki.search(List.first(names), flags)
      true -> :ok 
    end  
  end

  defp parse(args) do
    args |> OptionParser.parse(strict: @strict, aliases: @aliases)
  end

  defp show_help do
    """
    usage: wiki [term] [-#{@aliases |> Enum.map(fn {opt, _} -> opt end) |> Enum.join}]
    aliases:
     #{@aliases |> Enum.map(fn {opt, opt_extended} -> "[ -#{opt}, --#{opt_extended} ], #{Map.get(@description, opt)}\n\s" end)}
    """
    |> IO.puts
  end

  defp args_valid?(names, invalid) do
    cond do
      length(invalid) !== 0 ->
        invalid |> Enum.each(fn {flag, _} -> IO.puts("#{flag} is an invalid option.") end) 
        IO.puts("\n")
        show_help()
        false

      length(names) === 0 ->
        IO.puts("A term must be passed.\n")
        show_help()
        false

      length(names) > 1 ->
        IO.puts("Only one search term should be provided.\n")
        show_help()
        false

      true -> true
    end
  end

  defp tuple_contains?(tuple_list, atom) do
    Enum.member?(Enum.map(tuple_list, fn {key, _} -> key end), atom)
  end
end
