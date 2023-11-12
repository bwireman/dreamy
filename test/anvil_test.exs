defmodule AnvilTest do
  use ExUnit.Case
  doctest Anvil
  use Anvil

  test "fallthrough" do
    t =
      fallthrough 1 do
        3 -> :error
        1 -> :ok
      end

    assert t == :ok

    t =
      fallthrough 1 do
        2 -> :ok
        3 -> :error
      end

    assert t == 1
  end

  test "otherwise" do
    t =
      otherwise 1, nil do
        3 -> :error
        1 -> :ok
      end

    assert t == :ok

    t =
      otherwise 1, :error do
        2 -> :ok
        3 -> :error
      end

    assert t == :error
  end

  test "const" do
    const(:foo, "!@#")
    const(:bar, @foo)

    assert foo() == "!@#"
    assert @foo == "!@#"

    assert bar() == @foo
    assert @bar == @foo
  end

  test "~>" do
    assert {:ok, 1} ~> fn x -> x + 1 end == 2
    assert {:error, 1} ~> fn x -> x + 1 end == {:error, 1}
  end

  test "~>>" do
    assert {:ok, 1} ~>> fn {:ok, x} -> x + 1 end == 2
    assert {:error, 1} ~>> fn {:ok, x} -> x + 1 end == {:error, 1}
  end

  test "unwrap" do
    assert unwrap({:ok, 1}) == 1
    assert unwrap({:error, 1}) == {:error, 1}
  end

  test "through" do
    assert 0
           |> through(fn x -> x + 1 end)
           |> through(fn x -> x + 1 end)
           |> through(fn x -> x + 1 end) == 3
  end

  def double(x), do: x * 2

  test ">>>" do
    plus = fn x -> x + 1 end

    assert [4, 6, 8] ==
             [1, 2, 3] >>>
               plus >>>
               (&double/1)
  end
end
