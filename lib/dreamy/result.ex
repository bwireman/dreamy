defmodule Dreamy.Result do
  @moduledoc """
  Functions for use with :ok, and :error tuples
  """

  alias Dreamy.Option
  require Dreamy.Option

  @typedoc "Wrapper for :ok, and :error tuple"
  @type t(ok, error) :: {:ok, ok} | {:error, error}

  @doc """
  Returns an empty Option

  ## Examples
  ```
  iex> use Dreamy
  ...> ok("Hello World")
  {:ok, "Hello World"}
  ```
  """
  def ok(val), do: {:ok, val}

  @doc """
  Returns an error Result

  ## Examples
  ```
  iex> use Dreamy
  ...> error("err")
  {:error, "err"}
  ```
  """
  def error(val), do: {:error, val}

  defguard is_ok(v) when is_tuple(v) and tuple_size(v) == 2 and elem(v, 0) == :ok

  defguard is_error(v) when is_tuple(v) and tuple_size(v) == 2 and elem(v, 0) == :error

  defguard is_result(v) when is_ok(v) or is_error(v)

  @doc """
  Function getting the first :ok result if one exists
  If the right side is a function, only calling that function when the left is an error

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, "success"} ||| {:ok, "success 2"}
  {:ok, "success"}

  iex> use Dreamy
  ...> {:ok, "success"} ||| fn -> {:ok, "done"} end
  {:ok, "success"}

  iex> use Dreamy
  ...> {:error, "some error"} ||| fn -> {:ok, "done"} end
  {:ok, "done"}

  iex> use Dreamy
  ...> {:error, "oops"} ||| {:ok, "success 2"}
  {:ok, "success 2"}

  iex> use Dreamy
  ...> {:error, "oops"} ||| {:error, "darn"}
  {:error, "oops"}

  iex> use Dreamy
  ...> {:ok, "first try"} ||| {:error, "darn"} ||| {:ok, "finally"}
  {:ok, "first try"}

  iex> use Dreamy
  ...> {:error, "oops"} ||| {:error, "darn"} ||| {:ok, "finally"}
  {:ok, "finally"}

  iex> use Dreamy
  ...> {:error, "oops"} ||| {:error, "darn"} |||  fn -> {:ok, "finally"} end
  {:ok, "finally"}
  ```
  """
  @spec t(a, err_a) ||| t(b, any()) :: {:ok, a} | {:ok, b} | {:error, err_a}
        when a: var, b: var, err_a: var
  def ({:ok, _} = l) ||| fun when is_function(fun), do: l
  def {:error, _} ||| fun when is_function(fun), do: fun.()
  def ({:ok, _} = l) ||| _, do: l
  def {:error, _} ||| ({:ok, _} = r), do: r
  def ({:error, _} = l) ||| {:error, _}, do: l

  @doc """
  Function for extracting values from :ok records

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, "hello"}
  ...> |> unwrap
  "hello"

  iex> use Dreamy
  ...> {:error, "world"}
  ...> |> unwrap
  {:error, "world"}

  iex> use Dreamy
  ...> {:ok, "hello"}
  ...> |> unwrap("backup")
  "hello"

  iex> use Dreamy
  ...> {:error, "world"}
  ...> |> unwrap("backup")
  "backup"
  ```
  """
  @spec unwrap(t(x, y)) :: x | {:error, y} when x: var, y: var
  def unwrap({:ok, v}), do: v
  def unwrap({:error, v}), do: error(v)
  def unwrap({:ok, v}, _), do: v
  def unwrap({:error, _}, fallback), do: fallback

  @doc """
  Function for extracting values from :error tuples

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, "hello"}
  ...> |> unwrap_error
  {:ok, "hello"}

  iex> use Dreamy
  ...> {:error, "world"}
  ...> |> unwrap_error
  "world"
  ```
  """
  @spec unwrap_error(t(x, y)) :: {:ok, x} | y when x: var, y: var
  def unwrap_error({:ok, v}), do: ok(v)
  def unwrap_error({:error, v}), do: v

  @doc """
  Function for flipping results

  ## Examples
  ```
  iex> use Dreamy
  ...> flip({:ok, 3})
  {:error, 3}

  iex> use Dreamy
  ...> flip({:error, 3})
  {:ok, 3}
  ```
  """
  @spec flip(t(res, err)) :: t(err, res) when res: var, err: var
  def flip({:ok, v}), do: error(v)
  def flip({:error, v}), do: ok(v)

  @doc """
  Function to convert results to options

  ## Examples
  ```
  iex> use Dreamy
  ...> to_option({:ok, 3})
  {Dreamy.Option, 3}

  iex> use Dreamy
  ...> to_option({:error, 3})
  {Dreamy.Option, :empty}
  ```
  """
  def to_option({:ok, v}), do: Option.option(v)
  def to_option({:error, _}), do: Option.empty()

  @doc """
  Build an Result from an Option

  ## Examples
  ```
  iex> use Dreamy
  ...> empty()
  ...> |> from_option()
  {:error, nil}

  iex> use Dreamy
  ...> option("OK")
  ...> |> from_option()
  {:ok, "OK"}
  ```
  """
  def from_option(v) when Option.is_option(v), do: Option.to_result(v)
end
