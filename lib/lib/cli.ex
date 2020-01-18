defmodule Wiki.CLI do
  @wiki_locale "en"
  @strict [help: :boolean, briefs: :boolean, links: :integer, write: :boolean, locale: :string]
  @aliases [h: :help, b: :briefs, l: :links, w: :write, c: :locale]
  @description %{
    h: "show current help message",
    b: "show brief description of first few matching results",
    l: "show [x] wikipedia links matching input term",
    w: "write the term search result to an html file",
    c: "the locale used to fetch the term from wikimedia"
  }

  def main(args \\ []) do
    {flags, names, invalid} = parse(args)

    cond do 
      tuple_contains?(flags, :help) -> show_help()
      args_valid?(names, invalid) -> search_wiki(List.first(names), flags, invalid)
      true -> :ok  
    end  
  end

  defp search_wiki(term, flags, invalid) do
    locale = flags 
      |> Enum.find({:locale, @wiki_locale}, fn {key, _} -> key === :locale end) 
      |> elem(1)

    search_flags = case tuple_contains?(invalid, ["-l", "--links"]) do
      true -> Enum.concat(flags, [links: 1])
      _ -> flags
    end

    Wiki.search(term, search_flags, locale)
  end

  defp parse(args) do
    args |> OptionParser.parse(strict: @strict, aliases: @aliases)
  end

  defp show_help do
    """
    usage: wiki [term] [-#{@aliases |> Enum.map(&(elem(&1, 0))) |> Enum.join}]
    aliases:
     #{@aliases |> Enum.map(fn {opt, opt_extended} -> "[ -#{opt}, --#{opt_extended} ], #{Map.get(@description, opt)}\n\s" end)}
    """
    |> IO.puts
  end

  defp args_valid?(names, invalid) do
    cond do
      length(names) === 0 ->
        IO.puts("A term must be passed.\n")
        show_help()
        false

      length(invalid) === 1 and tuple_contains?(invalid, ["-l", "--links"]) ->
        true

      length(invalid) !== 0 ->
        invalid |> Enum.each(&(IO.puts("#{elem(&1, 0)} is an invalid option."))) 
        IO.puts("\n")
        show_help()
        false

      length(names) > 1 ->
        IO.puts("Only one search term should be provided.\n")
        show_help()
        false

      true -> true
    end
  end

  defp get_tuple_keys(tuple_list) do
    Enum.map(tuple_list, fn {key, _} -> key end)
  end

  defp tuple_contains?(tuple_list, item) do
    tuple_keys = get_tuple_keys(tuple_list)

    if is_list(item) do
      item |> Enum.any?(&(Enum.member?(tuple_keys, &1)))
    else
      Enum.member?(tuple_keys, item)
    end
  end
end
