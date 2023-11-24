defmodule DreamyTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy
  doctest Dreamy

  describe "fallthrough" do
    test "hit" do
      t =
        fallthrough 1 do
          3 -> :error
          1 -> :ok
        end

      assert t == :ok
    end

    test "miss" do
      t =
        fallthrough 1 do
          2 -> :ok
          3 -> :error
        end

      assert t == 1
    end
  end

  describe "otherwise" do
    test "hit" do
      t =
        otherwise 1, nil do
          3 -> :error
          1 -> :ok
        end

      assert t == :ok
    end

    test "miss" do
      t =
        otherwise 1, :error do
          2 -> :ok
          3 -> :error
        end

      assert t == :error
    end
  end

  describe "or_else" do
    test "hit" do
      x = "abc"

      t =
        or_else :ok do
          is_nil(x) -> {:error, nil}
          is_binary(x) -> {:error, :binary}
          is_number(x) -> {:error, :number}
          is_list(x) -> {:error, :list}
          is_map(x) -> {:error, :map}
        end

      assert t == {:error, :binary}
    end

    test "miss" do
      x = "abc"

      t =
        or_else :ok do
          is_nil(x) -> {:error, nil}
          is_number(x) -> {:error, :number}
          is_list(x) -> {:error, :list}
          is_map(x) -> {:error, :map}
        end

      assert t == :ok
    end
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
    assert {:ok, 1} ~>> fn x -> {:ok, x + 1} end == {:ok, 2}
    assert {:error, 1} ~>> fn x -> {:ok, x + 1} end == {:error, 1}
  end

  test "unwrap" do
    assert unwrap({:ok, 1}) == 1
    assert unwrap({:error, 1}) == {:error, 1}
  end

  defp double(x), do: x * 2

  test ">>>" do
    plus = fn x -> x + 1 end

    assert [4, 6, 8] ==
             [1, 2, 3] >>>
               plus >>>
               (&double/1)
  end
end
