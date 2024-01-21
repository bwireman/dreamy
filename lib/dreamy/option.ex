defmodule Dreamy.Option do
  @moduledoc """
  Functions for use with Options
  """

  import Dreamy

  @type t(v) :: {__MODULE__, v} | empty()
  @type empty() :: {__MODULE__, :empty}

  @doc """
  Returns an empty Option

  ## Examples
  ```
  iex> use Dreamy
  ...> empty()
  {Dreamy.Option, :empty}
  ```
  """
  const(:empty, {__MODULE__, :empty})

  defguard is_option(v) when is_tuple(v) and tuple_size(v) == 2 and elem(v, 0) == __MODULE__

  defguard is_empty(v) when is_option(v) and elem(v, 1) == :empty

  defguard is_some(v) when is_option(v) and not is_empty(v)

  @doc """
  builds an Option from a value

  ## Examples
  ```
  iex> use Dreamy
  ...> option(nil)
  {Dreamy.Option, :empty}

  iex> use Dreamy
  ...> empty() == option(nil)
  true

  iex> use Dreamy
  ...> option("Hello World")
  {Dreamy.Option, "Hello World"}
  ```
  """
  @spec option(Dreamy.Types.nullable(v)) :: t(v) when v: var
  def option(nil), do: @empty
  def option(val), do: {__MODULE__, val}

  @doc """
  Build an Option from a Result

  ## Examples
  ```
  iex> use Dreamy
  ...> from_result({:error, "err"})
  {Dreamy.Option, :empty}

  iex> use Dreamy
  ...> from_result({:ok, "OK"})
  {Dreamy.Option, "OK"}
  ```
  """
  @spec from_result(Dreamy.Result.t(ok, term())) :: t(ok) when ok: var
  def from_result({:ok, v}), do: option(v)
  def from_result({:error, _}), do: @empty

  @doc """
  Build an Result from an Option

  ## Examples
  ```
  iex> use Dreamy
  ...> empty()
  ...> |> to_result()
  {:error, nil}

  iex> use Dreamy
  ...> option("OK")
  ...> |> to_result()
  {:ok, "OK"}
  ```
  """
  @spec to_result(t(v)) :: {:ok, v} | {:error, nil} when v: var
  def to_result(@empty), do: {:error, nil}
  def to_result({__MODULE__, v}), do: {:ok, v}

  @doc """
  Get the value of an option

  ## Examples
  ```
  iex> use Dreamy
  ...> empty()
  ...> |> get()
  :error

  iex> use Dreamy
  ...> option("Hello World")
  ...> |> get()
  {:ok, "Hello World"}
  ```
  """
  @spec get(t(v)) :: {:ok, v} | :error when v: var
  def get(@empty), do: :error
  def get({__MODULE__, val}), do: {:ok, val}

  @doc """
  Get the value of an option, throwing an error if empty

  ## Examples
  ```
  iex> use Dreamy
  ...> empty()
  ...> |> get!()
  ** (RuntimeError) Empty Option

  iex> use Dreamy
  ...> option("Hello World")
  ...> |> get!()
  "Hello World"
  ```
  """
  @spec get!(t(v)) :: v when v: var
  def get!(@empty), do: raise("Empty Option")
  def get!({__MODULE__, val}), do: val
end
