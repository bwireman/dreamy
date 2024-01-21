# Dreamy 😴

[![ci](https://github.com/bwireman/dreamy/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/bwireman/dreamy/actions/workflows/elixir.yml)
[![mit](https://img.shields.io/github/license/bwireman/dreamy?color=brightgreen)](https://github.com/bwireman/dreamy/blob/main/LICENSE)
[![commits](https://img.shields.io/github/last-commit/bwireman/dreamy)](https://github.com/bwireman/dreamy/commit/main)
[![0.3.0](https://img.shields.io/hexpm/v/dreamy?color=brightgreen&style=flat)](https://hexdocs.pm/dreamy/readme.html)
[![downloads](https://img.shields.io/hexpm/dt/dreamy?color=brightgreen)](https://hex.pm/packages/dreamy/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](http://makeapullrequest.com)
![Dreamy 😴](https://img.shields.io/badge/Dreamy%20%F0%9F%98%B4-blue)

Dreamy provides useful macros, functions, types & operators to make elixir even dreamier 😴

- 📔 Docs: https://hexdocs.pm/dreamy/readme.html
- 💾 download: https://hex.pm/packages/dreamy

## Modules

- [`Dreamy`](https://hexdocs.pm/dreamy/Dreamy.html): Dreamy provides useful macros, functions, types & operators to make elixir even dreamier 😴
- [`Dreamy.Defaults`](https://hexdocs.pm/dreamy/Dreamy.Defaults.html): Helpers for dealing with Defaults for functions
- [`Dreamy.Either`](https://hexdocs.pm/dreamy/Dreamy.Either.html): Datatype for representing Either, Or
- [`Dreamy.Monodic`](https://hexdocs.pm/dreamy/Dreamy.Monodic.html): Functions for use with both Result and Option monads
- [`Dreamy.Option`](https://hexdocs.pm/dreamy/Dreamy.Option.html): Functions for use with Options
- [`Dreamy.Result`](https://hexdocs.pm/dreamy/Dreamy.Result.html): Functions for use with :ok, and :error tuples
- [`Dreamy.Types`](https://hexdocs.pm/dreamy/Dreamy.Types.html): Useful Type definitions

## Usage

```elixir
defmodule Example.Usage do
  use Dreamy

  # read file and split into a map of software => version,
  # -> %{"elixir" => "x.x.x", "erlang" => "x.x.x"}
  @spec versions() :: map()
  def versions do
    File.read!(".tool-versions")
    |> String.split("\n", parts: 2)
    >>> (&String.trim/1)
    >>> (&String.split/1)
    >>> (&List.to_tuple/1)
    |> Enum.into(%{})
  end

  defp foo(x), do: {:ok, x + 1}

  defp bar(x), do: {:ok, x * 2}

  # managing results without Dreamy
  def without_dreamy(x) do
    with {:ok, y} <- foo(x),
         {:ok, y} <- foo(y),
         {:ok, y} <- bar(y) do
      y
    end
  end

  # VS. with Dreamy
  def with_dreamy(x), do:
    foo(x)
    ~> (&foo/1)
    ~> (&bar/1)
    |> unwrap()
end
```

## Installation

[Available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dreamy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dreamy, "~> 0.3.0"}
  ]
end
```
