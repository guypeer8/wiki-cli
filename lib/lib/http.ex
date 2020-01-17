defmodule Wiki.HTTP do
  def get(url, parse_json \\ true) do
    %{body: body} = HTTPoison.get!(url)
    if parse_json, do: Poison.decode!(body), else: body
  end
end
