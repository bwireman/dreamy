defmodule Dreamy.Monodic do
  @moduledoc "Functions for use with a monads defined by Dreamy, including Result, Either & Option monads"

  alias Dreamy.{Either, Option, Result}
  require Dreamy.{Either, Option, Result}

  @type t(l, r) :: Option.t(l) | Either.t(l, r) | Result.t(l, r)

  defguard is_monodic(v) when Option.is_option(v) or Result.is_result(v) or Either.is_either(v)

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
  ...> {:error, 1}
  ...> ~> fn x -> x + 1 end
  {:error, 1}
  ```

  ## Option Examples
  ```
  iex> use Dreamy
  ...> empty()
  ...> ~> (fn _ -> :ok end)
  {Dreamy.Option, :empty}

  iex> use Dreamy
  ...> option(1)
  ...> ~> (fn x -> x + 1 end)
  {Dreamy.Option, 2}

  ## Either Examples
  ```
  iex> use Dreamy
  ...> left(:l)
  ...> ~> &Atom.to_string/1
  {Dreamy.Either, "l", nil}

  iex> use Dreamy
  ...> left(100)
  ...> ~> (fn l -> l + 1 end)
  {Dreamy.Either, 101, nil}
  ```
  """
  @spec Result.t(res, err) ~> (res -> x) :: Result.t(x, err)
        when res: var, err: var, x: var
  @spec Option.t(v) ~> (v -> x) :: Option.t(x) when v: var, x: var
  @spec Either.t(l, r) ~> (l -> x) :: Either.t(x, r)
        when l: var, r: var, x: var
  def {:ok, l} ~> r when is_function(r, 1), do: r.(l)
  def {:error, l} ~> r when is_function(r, 1), do: {:error, l}
  def {Dreamy.Option, :empty} ~> r when is_function(r, 1), do: Option.empty()
  def {Dreamy.Option, val} ~> r when is_function(r, 1), do: {Dreamy.Option, r.(val)}
  def v ~> r when is_function(r, 1) and Either.is_either(v), do: Either.map_left(v, r)

  @doc "Alias for Dreamy.Monodic.~>/2"
  @spec map(Result.t(res, err), (res -> x)) :: Result.t(x, err)
        when res: var, err: var, x: var
  @spec map(Option.t(v), (v -> x)) :: Option.t(x) when v: var, x: var
  @spec map(Either.t(l, r), (l -> x)) :: Either.t(x, r)
        when l: var, r: var, x: var
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
  ...> {:error, 1}
  ...> ~>> fn {:ok, x} -> {:ok, x + 1} end
  {:error, 1}
  ```

  ## Option Examples
  ```
  iex> use Dreamy
  ...> empty()
  ...> ~>> (fn x -> option(x + 2) end)
  {Dreamy.Option, :empty}

  iex> use Dreamy
  ...> option(1)
  ...> ~>> (fn x -> option(x + 2) end)
  {Dreamy.Option, 3}
  ```
  """
  @spec Result.t(res, err) ~>> (res -> Result.t(x, err)) :: Result.t(x, err)
        when res: var, err: var, x: var
  @spec Option.t(v) ~>> (v -> Option.t(x)) :: Option.t(x) when v: var, x: var
  @spec Either.t(l, r) ~>> (l -> Result.t(x, r)) :: Either.t(x, r)
        when l: var, r: var, x: var
  def {:ok, l} ~>> r when is_function(r, 1), do: r.(l)
  def ({:error, _} = l) ~>> r when is_function(r, 1), do: l
  def {Dreamy.Option, :empty} ~>> r when is_function(r, 1), do: Option.empty()
  def {Dreamy.Option, l} ~>> r when is_function(r, 1), do: r.(l)
  def v ~>> r when is_function(r, 1) and Either.is_either(v), do: Either.flat_map_left(v, r)

  @doc "Alias for Dreamy.Monodic.~>>/2"
  @spec flat_map(Result.t(res, err), (res -> Result.t(x, err))) :: Result.t(x, err)
        when res: var, err: var, x: var
  @spec flat_map(Option.t(v), (v -> Option.t(x))) :: Option.t(x) when v: var, x: var
  @spec flat_map(Either.t(l, r), (l -> Result.t(x, r))) :: Either.t(x, r)
        when l: var, r: var, x: var
  def flat_map(v, f), do: v ~>> f

  @doc """
  Function that flattens monads containing other monads

  ## Result Examples
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
  ```

  ## Option Examples
  ```
  iex> use Dreamy
  ...> flatten(option(option("Hello World")))
  {Option, "Hello World"}

  iex> use Dreamy
  ...> flatten(option(empty()))
  {Option, :empty}
  ```

  ## Either Examples
  ```
  iex> use Dreamy
  ...> flatten(left(right("Hello World")))
  {Either, nil, "Hello World"}

  iex> use Dreamy
  ...> flatten(right(left("Hello World")))
  {Either, "Hello World", nil}
  ```
  """
  @spec flatten(Result.t(Result.t(ok, err), term())) :: Result.t(ok, err) when ok: var, err: var
  @spec flatten(Result.t(term(), Result.t(ok, err))) :: Result.t(ok, err) when ok: var, err: var
  @spec flatten(Option.t(Option.t(v))) :: Option.t(v) when v: var
  @spec flatten(Either.t(Either.t(l, r), term())) :: Either.t(l, r) when l: var, r: var
  @spec flatten(Either.t(term(), Either.t(l, r))) :: Either.t(l, r) when l: var, r: var
  def flatten(val) do
    case val do
      {:ok, inner} when Result.is_result(inner) -> inner
      {:error, inner} when Result.is_result(inner) -> inner
      {Option, inner} when Option.is_option(inner) -> inner
      _ when Option.is_empty(val) -> val
      {Either, inner, _} when Either.is_either(inner) -> inner
      {Either, _, inner} when Either.is_either(inner) -> inner
    end
  end
end
