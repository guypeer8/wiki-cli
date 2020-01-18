defmodule Wiki do
  @wiki_base_api "https://en.wikipedia.org/w/api.php?utf8=&format=json"
  @wiki_briefs_api "#{@wiki_base_api}&action=query&list=search&srsearch="
  @wiki_opensearch_api "#{@wiki_base_api}&action=opensearch&namespace=0&search="
  @wikidocs "wikidocs"

  defp get_api(:briefs, term), do: "#{@wiki_briefs_api}#{URI.encode(term)}"
  defp get_api(:opensearch, term), do: "#{@wiki_opensearch_api}#{URI.encode(term)}"

  defp get_matched_urls(term, show_urls_num \\ 3, log_results \\ false) do
    data = Wiki.HTTP.get(get_api(:opensearch, term))

    unless is_list(data) and Enum.count(List.last(data)) > 0 do
      if log_results do
        IO.puts("No results found for search term: `#{term}`")
      end
      []
    else
      results = data
        |> List.last
        |> Enum.take(show_urls_num)

      if log_results do
        Enum.each(results, &IO.puts/1)
      end
      results
    end
  end

  defp search_briefs(term) do
    data = Wiki.HTTP.get(get_api(:briefs, term))
    search_results = data["query"]["search"]
    show_search_results(term, search_results)
  end

  defp show_search_results(term, search_results, show_results_num \\ 3) do
    if Enum.count(search_results) === 0 do
      IO.puts("No results found for search term: `#{term}`")
    else
      search_results
        |> Enum.take(show_results_num)
        |> Enum.each(&print_result/1)
    end
  end

  defp print_result(result) do
    title = result["title"]
    body = clean_search_result(result["snippet"])
    IO.puts("** #{title}:\n#{body}\n\n")
  end

  defp clean_search_result(search_result) do
    [~r/<span\s+class="searchmatch">/, ~r/<\/span>/] 
      |> Enum.reduce(search_result, &(Regex.replace(&1, &2, "\\1")))
      |> String.replace("&quot;", "")
  end

  defp to_html(term) do
    term_api = get_matched_urls(term, 1)
    html = Wiki.HTTP.get(term_api, false)
    unless File.exists?(@wikidocs), do: File.mkdir!(@wikidocs)

    term_path = "./#{@wikidocs}/#{term}.html"
    if File.exists?(term_path) do
      IO.puts("\"#{term_path}\" file already exists.")
    else
      File.write!(term_path, html)
    end
  end

  def search(term, flags) do
    map_flags = case flags do
      [] -> [briefs: true]
      _ -> flags
    end

    cli_flags = map_flags 
    |> Enum.reduce(%{}, fn {key, val}, acc ->
        Map.put(acc, key, val)
      end)
    
    if Map.has_key?(cli_flags, :briefs) do
       search_briefs(term)
    end

    if Map.has_key?(cli_flags, :links) do
       get_matched_urls(term, Map.get(cli_flags, :links, 1), true)
    end

    if Map.has_key?(cli_flags, :write) do
      to_html(term)
    end
  end
end
