defmodule Dreamy.Either do
  alias Dreamy.Option
  @moduledoc "Datatype for representing Either, Or"

  @typedoc "Monodic type representing a left or right tuple"
  @type t(l, r) :: {__MODULE__, l, r}
  @type left(l) :: t(l, nil)
  @type right(r) :: t(nil, r)
  @type neither() :: t(nil, nil)

  defguard is_either(v) when is_tuple(v) and tuple_size(v) == 3 and elem(v, 0) == __MODULE__
  defguard is_left(v) when is_either(v) and not is_nil(elem(v, 1)) and is_nil(elem(v, 2))
  defguard is_right(v) when is_either(v) and is_nil(elem(v, 1)) and not is_nil(elem(v, 2))
  defguard is_neither(v) when is_either(v) and is_nil(elem(v, 1)) and is_nil(elem(v, 2))

  @doc """
  Returns an Either tuple

  ## Examples
  ```
  iex> use Dreamy
  ...> either(:l, :r)
  {Dreamy.Either, :l, :r}
  ```
  """
  @spec either(l, r) :: t(l, r) when l: var, r: var
  def either(l, r), do: {__MODULE__, l, r}

  @doc """
  Returns an empty Either tuple, aka a Neither

  ## Examples
  ```
  iex> use Dreamy
  ...> neither()
  {Dreamy.Either, nil, nil}
  ```
  """
  @spec neither() :: neither()
  def neither, do: either(nil, nil)

  @doc """
  Returns an Either tuple with left value populated, and the right nil

  ## Examples
  ```
  iex> use Dreamy
  ...> left(:l)
  {Dreamy.Either, :l, nil}
  ```
  """
  @spec left(l) :: left(l) when l: var
  def left(v), do: either(v, nil)

  @doc """
  Returns an Either tuple with right value populated, and the left nil

  ## Examples
  ```
  iex> use Dreamy
  ...> right(:r)
  {Dreamy.Either, nil, :r}
  ```
  """
  @spec right(r) :: right(r) when r: var
  def right(v), do: either(nil, v)

  @doc """
  Returns the left value from an Either tuple

  ## Examples
  ```
  iex> use Dreamy
  ...> either(:l, :r)
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
  iex> use Dreamy
  ...> either(:l, :r)
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
  iex> use Dreamy
  ...> left(:l)
  ...> |> map_left(&Atom.to_string/1)
  {Dreamy.Either, "l", nil}

  iex> use Dreamy
  ...> right(:r)
  ...> |> map_left(&Atom.to_string/1)
  {Dreamy.Either, nil, :r}

  iex> use Dreamy
  ...> neither()
  ...> |> map_left(&Atom.to_string/1)
  {Dreamy.Either, nil, nil}
  ```
  """
  @spec map_left(left(l), (l -> res)) :: left(res) when l: var, res: var
  @spec map_left(right(r), (nil -> term())) :: right(r) when l: var, r: var
  def map_left(v, _) when is_neither(v), do: neither()
  def map_left({__MODULE__, nil, r}, _), do: right(r)
  def map_left({__MODULE__, l, nil}, fun), do: left(fun.(l))

  @doc """
  Applies the function to the right value

  ## Examples
  ```
  iex> use Dreamy
  ...> right(:r)
  ...> |> map_right(&Atom.to_string/1)
  {Dreamy.Either, nil, "r"}

  iex> use Dreamy
  ...> left(:l)
  ...> |> map_right(&Atom.to_string/1)
  {Dreamy.Either, :l, nil}

  iex> use Dreamy
  ...> neither()
  ...> |> map_right(&Atom.to_string/1)
  {Dreamy.Either, nil, nil}
  ```
  """
  @spec map_right(right(r), (r -> res)) :: right(res) when r: var, res: var
  @spec map_right(left(l), (nil -> term())) :: left(l) when l: var, r: var
  def map_right(v, _) when is_neither(v), do: neither()
  def map_right({__MODULE__, l, nil}, _), do: left(l)
  def map_right({__MODULE__, nil, r}, fun), do: right(fun.(r))

  @doc """
  Applies the function to the left value and flattens

  ## Examples
  ```
  iex> use Dreamy
  ...> left(:l)
  ...> |> flat_map_left(fn _ -> left(:new_left) end)
  {Dreamy.Either, :new_left, nil}

  iex> use Dreamy
  ...> right(:r)
  ...> |> flat_map_left(fn _ -> left(:new_left) end)
  {Dreamy.Either, nil, :r}

  iex> use Dreamy
  ...> neither()
  ...> |> flat_map_left(&Atom.to_string/1)
  {Dreamy.Either, nil, nil}
  ```
  """
  @spec flat_map_left(left(l), (l -> left(res))) :: left(res) when l: var, res: var
  @spec flat_map_left(right(r), (nil -> left(term()))) :: right(r) when r: var
  def flat_map_left(v, _) when is_neither(v), do: neither()
  def flat_map_left({__MODULE__, nil, r}, _), do: right(r)
  def flat_map_left({__MODULE__, l, nil}, fun), do: l |> fun.() |> get_left() |> left()

  @doc """
  Applies the function to the right value and flattens

  ## Examples
  ```
  iex> use Dreamy
  ...> right(:r)
  ...> |> flat_map_right(fn _ -> right(:new_right) end)
  {Dreamy.Either, nil, :new_right}

  iex> use Dreamy
  ...> left(:l)
  ...> |> flat_map_right(fn _ -> right(:new_right) end)
  {Dreamy.Either, :l, nil}

  iex> use Dreamy
  ...> neither()
  ...> |> flat_map_right(&Atom.to_string/1)
  {Dreamy.Either, nil, nil}
  ```
  """
  @spec flat_map_right(right(r), (r -> right(res))) :: right(res) when r: var, res: var
  @spec flat_map_right(left(l), (nil -> right(term()))) :: left(l) when l: var
  def flat_map_right(v, _) when is_neither(v), do: neither()
  def flat_map_right({__MODULE__, l, nil}, _), do: left(l)

  def flat_map_right({__MODULE__, nil, r}, fun) do
    res = r |> fun.() |> get_right()

    right(res)
  end

  @doc """
  Wraps the left value in a Dreamy.Option, returns an empty if the value is nil

  ## Examples
  ```
  iex> use Dreamy
  ...> left(:l)
  ...> |> to_option_left()
  {Dreamy.Option, :l}

  iex> use Dreamy
  ...> right(:r)
  ...> |> to_option_left()
  {Dreamy.Option, :empty}
  ```
  """
  @spec to_option_left(left(l)) :: Dreamy.Types.option(l) when l: var
  @spec to_option_left(right(term())) :: Option.empty()
  def to_option_left(v) when is_left(v),
    do:
      v
      |> get_left()
      |> Option.option()

  def to_option_left(_), do: Option.empty()

  @doc """
  Wraps the right value in a Dreamy.Option, returns an empty if the value is nil

  ## Examples
  ```
  iex> use Dreamy
  ...> right(:r)
  ...> |> to_option_right()
  {Dreamy.Option, :r}

  iex> use Dreamy
  ...> left(:l)
  ...> |> to_option_right()
  {Dreamy.Option, :empty}
  ```
  """
  @spec to_option_right(right(r)) :: Dreamy.Types.option(r) when r: var
  @spec to_option_right(left(term())) :: Option.empty()
  def to_option_right(v) when is_right(v),
    do:
      v
      |> get_right()
      |> Option.option()

  def to_option_right(_), do: Option.empty()
end
