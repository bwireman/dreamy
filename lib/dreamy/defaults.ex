defmodule Dreamy.Defaults do
  @moduledoc false

  @doc """
  Function for extracting the default opts
  as provided and returns them in a variable sized tuple
  in defaults order

  ```
  iex> use Dreamy
  ...> opts = [a: 1, b: 2]
  ...> defaults = [a: -1, b: -2, c: -3]
  ...> {1, 2, -3} = parse_defaults(opts, defaults)
  ```
  """
  def parse_defaults(opts, defaults) when is_list(defaults) do
    if not Keyword.keyword?(defaults) do
      raise "defaults must be a Keyword"
    end

    Enum.map(defaults, fn {key, value} ->
      Access.get(opts, key, value)
    end)
    |> List.to_tuple()
  end
end
