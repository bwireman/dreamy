defmodule Dreamy.Either do
  @moduledoc "Datatype for representing Either, Or"

  @typedoc "Monodic type representing a left or right tuple"
  @type t(l, r) :: {__MODULE__, l, r}
  @type left(l, _r) :: t(l, nil)
  @type right(_l, r) :: t(nil, r)

  defguard is_either(v) when is_tuple(v) and tuple_size(v) == 3 and elem(v, 0) == __MODULE__

  defguard is_left(v) when is_either(v) and not is_nil(elem(v, 1)) and is_nil(elem(v, 2))
  defguard is_right(v) when is_either(v) and is_nil(elem(v, 1)) and not is_nil(elem(v, 2))

  @doc """
  Returns an Either tuple

  ## Examples
  ```
  use Dreamy
  iex> either(:l, :r)
  {Dreamy.Either, :l, :r}
  ```
  """
  @spec either(l, r) :: t(l, r) when l: var, r: var
  def either(l, r), do: {__MODULE__, l, r}

  @doc """
  Returns an Either tuple with left value populated, and the right nil

  ## Examples
  ```
  use Dreamy
  iex> left(:l)
  {Dreamy.Either, :l, nil}
  ```
  """
  @spec left(l) :: left(l, nil) when l: var
  def left(v), do: either(v, nil)

  @doc """
  Returns an Either tuple with right value populated, and the left nil

  ## Examples
  ```
  use Dreamy
  iex> right(:r)
  {Dreamy.Either, nil, :r}
  ```
  """
  @spec right(r) :: right(nil, r) when r: var
  def right(v), do: either(nil, v)

  @doc """
  Returns the left value from an Either tuple

  ## Examples
  ```
  use Dreamy
  iex> either(:l, :r)
  ...> |> get_left()
  :l
  ```
  """
  @spec get_left(t(l, any())) :: l when l: var
  def get_left({__MODULE__, l, _}), do: l

  @doc """
  Returns the right value from an Either tuple

  ## Examples
  ```
  use Dreamy
  iex> either(:l, :r)
  ...> |> get_right()
  :r
  ```
  """
  @spec get_right(t(any(), r)) :: r when r: var
  def get_right({__MODULE__, _, r}), do: r

  @doc """
  Applies the function to the left value

  ## Examples
  ```
  use Dreamy
  iex> either(:l, :r)
  ...> |> map_left(&Atom.to_string/1)
  {Dreamy.Either, "l", :r}
  ```
  """
  def map_left({__MODULE__, l, r}, fun), do: either(fun.(l), r)

  @doc """
  Applies the function to the right value

  ## Examples
  ```
  use Dreamy
  iex> either(:l, :r)
  ...> |> map_right(&Atom.to_string/1)
  {Dreamy.Either, :l, "r"}
  ```
  """
  def map_right({__MODULE__, l, r}, fun), do: either(l, fun.(r))

  @doc """
  Applies the function to the left value and flattens

  ## Examples
  ```
  use Dreamy
  iex> either(:l, :r)
  ...> |> flat_map_left(fn _ -> left(:new_left) end)
  {Dreamy.Either, :new_left, :r}
  ```
  """
  def flat_map_left({__MODULE__, l, r}, fun), do: l |> fun.() |> get_left() |> either(r)

  @doc """
  Applies the function to the right value and flattens

  ## Examples
  ```
  use Dreamy
  iex> either(:l, :r)
  ...> |> flat_map_right(fn _ -> right(:new_right) end)
  {Dreamy.Either, :l, :new_right}
  ```
  """
  def flat_map_right({__MODULE__, l, r}, fun) do
    res = r |> fun.() |> get_right()

    either(l, res)
  end
end
