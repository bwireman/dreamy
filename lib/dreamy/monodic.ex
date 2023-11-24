defmodule Dreamy.Monodic do
  @moduledoc """
  Functions for use with both Result and Option monads
  """

  alias Dreamy.{Option, Result}
  require Dreamy.{Option, Result}

  @doc """
  Function for applying result tuples & options on success only

  ## Result Examples
  ```
  iex> use Dreamy
  ...> {:ok, 1}
  ...> ~> fn x -> {:ok, x + 1} end
  ...> ~> fn y -> y + 1 end
  3

  iex> use Dreamy
  ...> {:error, 1} ~> fn x -> x + 1 end
  {:error, 1}
  ```

  ## Option Examples
  ```
  iex> use Dreamy
  ...> empty() ~> (fn _ -> :ok end)
  {Dreamy.Option, :empty}

  iex> use Dreamy
  ...> option(1) ~> (fn x -> x + 1 end)
  {Dreamy.Option, 2}
  ```
  """
  @spec Result.t(res, err) ~> (res -> x) :: Result.t(x, err)
        when res: var, err: var, x: var
  @spec Option.t(v) ~> (v -> x) :: Option.t(x) when v: var, x: var
  def {:ok, l} ~> r when is_function(r), do: r.(l)
  def {:error, l} ~> r when is_function(r), do: {:error, l}
  def {Dreamy.Option, :empty} ~> r when is_function(r), do: Option.empty()
  def {Dreamy.Option, val} ~> r when is_function(r), do: {Dreamy.Option, r.(val)}

  @doc "Same as ~>"
  def map(v, f), do: v ~> f

  @doc """
  Function for applying result tuples & options on success only

  ## Result Examples
  ```
  iex> use Dreamy
  ...> {:ok, 1}
  ...> ~>> fn x -> {:ok, x + 1} end
  ...> ~>> fn x -> {:ok, x * 2} end
  {:ok, 4}

  iex> use Dreamy
  ...> {:error, 1} ~>> fn {:ok, x} -> {:ok, x + 1} end
  {:error, 1}
  ```

  ## Option Examples
  ```
  iex> use Dreamy
  ...> empty() ~>> (fn x -> option(x + 2) end)
  {Dreamy.Option, :empty}

  iex> use Dreamy
  ...> option(1) ~>> (fn x -> option(x + 2) end)
  {Dreamy.Option, 3}
  ```
  """
  @spec Result.t(res, err) ~> (res -> Result.t(x, err)) :: Result.t(x, err)
        when res: var, err: var, x: var
  @spec Option.t(v) ~> (v -> Option.t(x)) :: Option.t(x) when v: var, x: var
  def {:ok, l} ~>> r when is_function(r), do: r.(l)
  def ({:error, _} = l) ~>> r when is_function(r), do: l

  def {Dreamy.Option, :empty} ~>> r when is_function(r), do: Option.empty()
  def {Dreamy.Option, l} ~>> r when is_function(r), do: r.(l)

  @doc "Same as ~>>"
  def flat_map(v, f), do: v ~>> f

  @doc """
  Function that flattens monads containing other monads

  # Example
  ```
  iex> use Dreamy
  ...> flatten(ok(ok("Hello World")))
  {:ok, "Hello World"}

  iex> use Dreamy
  ...> flatten(ok(error("Hello World")))
  {:error, "Hello World"}

  iex> use Dreamy
  ...> flatten(error(ok("Hello World")))
  {:ok, "Hello World"}

  iex> use Dreamy
  ...> flatten(error(error("Hello World")))
  {:error, "Hello World"}

  iex> use Dreamy
  ...> flatten(option(option("Hello World")))
  {Option, "Hello World"}

  iex> use Dreamy
  ...> flatten(option(empty()))
  {Option, :empty}
  ```
  """
  def flatten(val) do
    case val do
      {:ok, inner} when Result.is_result(inner) -> inner
      {:error, inner} when Result.is_result(inner) -> inner
      {Option, inner} when Option.is_option(inner) -> inner
    end
  end
end
