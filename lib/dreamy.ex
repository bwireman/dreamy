defmodule Dreamy do
  @moduledoc """
  Dreamy provides useful macros & operators to make elixir even more dreamy
  """

  defmacro __using__(_) do
    quote do
      import IO, only: [inspect: 1, inspect: 2, inspect: 3]
      alias Dreamy.Types

      import Dreamy,
        only: [
          fallthrough: 2,
          otherwise: 3,
          const: 2,
          through: 2,
          unwrap: 1,
          unwrap_error: 1,
          flip: 1,
          ~>: 2,
          ~>>: 2,
          >>>: 2
        ]
    end
  end

  defmodule Types do
    @moduledoc """
    Useful Type definitions
    """

    @type nullable(t) :: t | nil
    @type result(ok, error) :: {:ok, ok} | {:error, error}
  end

  @doc """
  Macro for adding a default catchall -> clause to case statements, that returns the input value

  ## Examples
  ```
  iex> use Dreamy
  ...> fallthrough 1 do
  ...> 2 -> 2
  ...> end
  1

  iex> use Dreamy
  ...> fallthrough 2 do
  ...> 2 -> 2
  ...> end
  2
  ```
  """
  defmacro fallthrough(val, do: code) do
    code =
      code ++
        [
          {:->, [], [[{:other, [], nil}], {:other, [], nil}]}
        ]

    quote do
      case unquote(val) do
        unquote(code)
      end
    end
  end

  @doc """
  Macro for adding a default catchall -> clause to case statements, that returns the default value

  ## Examples
  ```
  iex> use Dreamy
  ...> otherwise 1, nil do
  ...> 2 -> 2
  ...> end
  nil

  iex> use Dreamy
  ...> otherwise 2, nil do
  ...> 2 -> 2
  ...> end
  2
  ```
  """
  defmacro otherwise(val, default, do: code) do
    code =
      code ++
        [
          {:->, [], [[{:_, [], nil}], default]}
        ]

    quote do
      case unquote(val) do
        unquote(code)
      end
    end
  end

  @doc """
  Macro for defining a constant attribute and function

  ## Examples
  ```
  iex> use Dreamy
  iex> const :example, "XYZ"
  iex> @example
  "XYZ"

  iex> example()
  "XYZ"
  ```
  """
  defmacro const(name, code) do
    caller = __CALLER__.module

    Module.register_attribute(caller, name, accumulate: false)

    Module.eval_quoted(
      caller,
      quote do
        Module.put_attribute(__MODULE__, unquote(name), unquote(code))
        def unquote(name)(), do: unquote(code)
      end
    )
  end

  @doc """
  function for applying anonymous functions

  ## Examples
  ```
  iex> use Dreamy
  iex> 2 |>
  iex> through(fn x -> x - 1 end) |>
  iex> through(fn x -> x - 1 end)
  0
  ```
  """
  def through(v, fun), do: fun.(v)

  @doc """
  Function for extracting values from :ok records

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, "hello"} |> unwrap
  "hello"

  iex> use Dreamy
  ...> {:error, "world"} |> unwrap
  {:error, "world"}
  ```
  """
  @spec unwrap(Types.result(x, y)) :: x | {:error, y} when x: var, y: var
  def unwrap({:ok, v}), do: v
  def unwrap({:error, v}), do: {:error, v}

  @doc """
  Function for extracting values from :error tuples

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, "hello"} |> unwrap_error
  {:ok, "hello"}

  iex> use Dreamy
  ...> {:error, "world"} |> unwrap_error
  "world"
  ```
  """
  @spec unwrap_error(Types.result(x, y)) :: {:ok, x} | y when x: var, y: var
  def unwrap_error({:ok, v}), do: {:ok, v}
  def unwrap_error({:error, v}), do: v

  @doc """
  Function for applying result tuples on success only

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, 1} ~>
  ...> fn x -> {:ok, x + 1} end ~>
  ...> fn y -> y + 1 end
  3

  iex> use Dreamy
  ...> {:error, 1} ~> fn x -> x + 1 end
  {:error, 1}
  ```
  """
  @spec Types.result(res, err) ~> (res -> x) :: x | {:error, err} when res: var, err: var, x: var
  def {:ok, l} ~> r when is_function(r), do: r.(l)
  def {:error, l} ~> r when is_function(r), do: {:error, l}

  @doc """
  Operator short hand for Enum.map

  ## Examples
  ```
  iex> use Dreamy
  ...> x = fn y -> y + 1 end
  ...> [1, 2]
  ...> >>> (&IO.inspect/1)
  ...> >>> x
  [2, 3]
  ```
  """
  defmacro enumerable >>> func do
    quote do
      Enum.map(unquote(enumerable), unquote(func))
    end
  end

  @doc """
  Function for applying result tuples on success only

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, 1} ~>>
  ...> fn {:ok, x} -> {:ok, x + 1} end ~>>
  ...> fn {:ok, x} -> {:ok, x + 1} end
  {:ok, 3}

  iex> use Dreamy
  ...> {:error, 1} ~>> fn {:ok, x} -> {:ok, x + 1} end
  {:error, 1}
  ```
  """
  @spec Types.result(res, err) ~>> (Types.result(res, err) -> x) :: x | {:error, err}
        when res: var, err: var, x: var
  def ({:ok, _} = l) ~>> r when is_function(r), do: r.(l)
  def ({:error, _} = l) ~>> r when is_function(r), do: l

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
  @spec flip(Types.result(res, err)) :: Types.result(err, res) when res: var, err: var
  def flip({:ok, v}), do: {:error, v}
  def flip({:error, v}), do: {:ok, v}
end
