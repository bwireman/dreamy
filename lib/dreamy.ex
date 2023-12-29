defmodule Dreamy do
  @moduledoc """
  Dreamy provides useful macros, functions, types & operators to make elixir even dreamier 😴
  """

  defmacro __using__(_) do
    quote do
      alias Dreamy.{Defaults, Either, Option, Result, Types}
      import Dreamy.{Defaults, Either, Monodic, Option, Result}

      import Dreamy,
        only: [
          fallthrough: 2,
          otherwise: 3,
          or_else: 2,
          const: 2,
          >>>: 2
        ]
    end
  end

  defmodule Types do
    @moduledoc "Useful Type definitions"

    @typedoc "Type union of `t` & `nil`"
    @type nullable(t) :: t | nil

    @typedoc "Type for documenting the value within an enumerable"
    @type enumerable(_t) :: Enumerable.t()

    @typedoc "Monodic type that can hold a value"
    @type option(t) :: Dreamy.Option.t(t)

    @typedoc "Monodic type for :ok, :error tuples"
    @type result(ok, err) :: Dreamy.Result.t(ok, err)

    @typedoc "Monodic type representing a left or right tuple"
    @type either(l, r) :: Dreamy.Either.t(l, r)
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
end
