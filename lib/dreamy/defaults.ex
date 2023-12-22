defmodule Dreamy.Defaults do
  import Dreamy
  @moduledoc "Helpers for dealing with Defaults for functions"

  @doc """
  Function for extracting the default opts
  as provided and returns them in a variable sized tuple
  in defaults order

  ```
  iex> use Dreamy
  ...> opts = [a: 1, b: 2]
  ...> defaults = [a: -1, b: -2, c: -3]
  ...> parse_defaults!(opts, defaults)
  {1, 2, -3}
  ```
  """
  @spec parse_defaults!(Access.t(), keyword()) :: tuple()
  def parse_defaults!(opts, defaults) do
    if not Keyword.keyword?(defaults) do
      raise "defaults must be a Keyword"
    end

    Enum.map(defaults, fn {key, value} ->
      Access.get(opts, key, value)
    end)
    |> List.to_tuple()
  end

  @doc """
  Function for extracting booleans from strings.
  Useful in configs

  ## Options
  - default: (false) bool to be used when the value could not be parsed

  ```
  iex> use Dreamy
  ...> parse_bool("TRUE")
  true
  ...> parse_bool("faLse")
  false
  ...> parse_bool("", default: true)
  true
  ...> parse_bool(nil, default: true)
  true
  ```
  """
  @spec parse_bool(String.t(), keyword()) :: boolean()
  def parse_bool(str, opts \\ [])

  def parse_bool(str, opts) when is_binary(str) do
    {default} = parse_defaults!(opts, default: false)

    otherwise String.downcase(str), default do
      # an empty string should also return the default
      "" -> default
      "true" -> true
      "t" -> true
      "y" -> true
      "yes" -> true
      "1" -> true
      "false" -> false
      "f" -> false
      "n" -> false
      "no" -> false
      "0" -> false
    end
  end

  def parse_bool(_, opts) do
    {default} = parse_defaults!(opts, default: false)
    default
  end

  @doc """
  Function for extracting integers from strings.
  Useful in configs

  ## Options
  - default: (0) int to be used when the value could not be parsed
  - base: (10) base to parse the integer as
  - remainder_allowed?: (false) wether or not to allow the integer to be followed by an arbitrary string
    - See Integer.parse/2 for more info

  ```
  iex> use Dreamy
  ...> parse_int("123")
  123
  ```
  ```
  iex> use Dreamy
  ...> parse_int("deadbeef", base: 16)
  3735928559
  ```
  ```
  iex> use Dreamy
  ...> parse_int("123abc", remainder_allowed?: true, default: -1)
  123
  ```
  ```
  iex> use Dreamy
  ...> parse_int("123abc", remainder_allowed?: false, default: -1)
  -1
  ```
  """
  @spec parse_int(String.t(), keyword()) :: integer()
  def parse_int(str, opts \\ []) do
    {default, base, rem} = parse_defaults!(opts, default: 0, base: 10, remainder_allowed?: false)

    otherwise Integer.parse(str, base), default do
      {v, _} when rem -> v
      {v, ""} -> v
    end
  end

  @doc """
  Function for extracting floats from strings.
  Useful in configs

  ## Options
  - default: (0.0) float to be used when the value could not be parsed
  - remainder_allowed?: (false) wether or not to allow the float to be followed by an arbitrary string
    - See Float.parse/1 for more info

  ```
  iex> use Dreamy
  ...> parse_float("3.14")
  3.14
  ```
  ```
  iex> use Dreamy
  ...> parse_float("1.23abc", remainder_allowed?: true, default: 0.1)
  1.23
  ```
  ```
  iex> use Dreamy
  ...> parse_float("123abc", remainder_allowed?: false, default: 0.1)
  0.1
  ```
  """
  @spec parse_float(String.t(), keyword()) :: float()
  def parse_float(str, opts \\ []) do
    {default, rem} = parse_defaults!(opts, default: 0.0, remainder_allowed?: false)

    otherwise Float.parse(str), default do
      {v, _} when rem -> v
      {v, ""} -> v
    end
  end
end
