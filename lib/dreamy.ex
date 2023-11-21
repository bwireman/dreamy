defmodule Dreamy do
  @moduledoc """
  Dreamy provides useful macros, functions, types & operators to make elixir even more dreamy 😴
  """

  defmacro __using__(_) do
    quote do
      import IO, only: [inspect: 1, inspect: 2, inspect: 3]
      alias Dreamy.Types

      import Dreamy,
        only: [
          fallthrough: 2,
          otherwise: 3,
          or_else: 2,
          const: 2,
          through: 2,
          unwrap: 1,
          unwrap_error: 1,
          flip: 1,
          ~>: 2,
          ~>>: 2,
          >>>: 2,
          |||: 2
        ]
    end
  end

  defmodule Types do
    @moduledoc """
    Useful Type definitions
    """

    @typedoc "Type union of `t` & `nil`"
    @type nullable(t) :: t | nil

    @typedoc "Type for documenting the value within an enumerable"
    @type enumerable(_t) :: Enumerable.t()

    @typedoc "Wrapper for :ok, and :error tuple"
    @type result(ok, error) :: {:ok, ok} | {:error, error}
  end

  @doc """
  Macro for adding a default catchall -> clause to case statements, that returns the input value

  ## Examples
  ```
  iex> use Dreamy
  ...> fallthrough {:error, "error"} do
  ...> {:ok, v} -> v
  ...> end
  {:error, "error"}

  iex> use Dreamy
  ...> fallthrough {:ok, "OK"} do
  ...> {:ok, "OK"} -> "OK"
  ...> end
  "OK"
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
  ...> otherwise nil, {:error, :not_found} do
  ...> {:ok, _} -> :ok
  ...> end
  {:error, :not_found}

  iex> use Dreamy
  ...> otherwise {:ok, nil}, {:error, :not_found} do
  ...> {:ok, _} -> :ok
  ...> end
  :ok
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
  Macro for adding a default catchall `true` clause to cond statements, that returns the default value

  ## Examples
  ```
  iex> use Dreamy
  ...> x = 5
  ...> or_else "Less than 10" do
  ...> x == 10 -> "10"
  ...> x > 10 -> "Greater than 10"
  ...> end
  "Less than 10"

  iex> use Dreamy
  ...> x = 11
  ...> or_else "Less than 10" do
  ...> x == 10 -> "10"
  ...> x > 10 -> "Greater than 10"
  ...> end
  "Greater than 10"
  ```
  """
  defmacro or_else(default, do: code) do
    code =
      code ++
        [
          {:->, [], [[true], default]}
        ]

    quote do
      cond do
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
  iex> 2
  ...> |> through(fn x -> x - 1 end)
  ...> |> through(fn x -> x - 1 end)
  0
  ```
  """
  @spec through(a, (a -> b)) :: b when a: var, b: var
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

  @doc """
  Function for applying result tuples on success only

  ## Examples
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
  """
  @spec Types.result(res, err) ~> (res -> x) :: x | {:error, err} when res: var, err: var, x: var
  def {:ok, l} ~> r when is_function(r), do: r.(l)
  def {:error, l} ~> r when is_function(r), do: {:error, l}

  @doc """
  Operator for Enum.map

  ## Examples
  ```
  iex> use Dreamy
  ...> x = fn y -> y + 1 end
  ...> y = fn z -> z * 2 end
  ...> [1, 2]
  ...> >>> x
  ...> >>> y
  [4, 6]

  iex> use Dreamy
  ...> x = fn y -> y - 1 end
  ...> [5, 7]
  ...> >>> x
  ...> >>> (&div(&1, 2))
  ...> >>> x
  [1, 2]
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
  ...> {:ok, 1}
  ...> ~>> fn {:ok, x} -> {:ok, x + 1} end
  ...> ~>> fn {:ok, x} -> {:ok, x * 2} end
  {:ok, 4}

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
  Function getting the first :ok result if one exists

  ## Examples
  ```
  iex> use Dreamy
  ...> {:ok, "success"} ||| {:ok, "success 2"}
  {:ok, "success"}

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
  ```
  """
  @spec Types.result(a, err_a) ||| Types.result(b, any()) :: {:ok, a} | {:ok, b} | {:error, err_a}
        when a: var, b: var, err_a: var
  def ({:ok, _} = l) ||| _, do: l
  def {:error, _} ||| ({:ok, _} = r), do: r
  def ({:error, _} = l) ||| {:error, _}, do: l
end
