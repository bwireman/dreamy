# Dreamy

[![ci](https://github.com/bwireman/dreamy/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/bwireman/dreamy/actions/workflows/elixir.yml)
[![mit](https://img.shields.io/github/license/bwireman/dreamy?color=brightgreen)](https://github.com/bwireman/dreamy/blob/main/LICENSE)
[![commits](https://img.shields.io/github/last-commit/bwireman/dreamy)](https://github.com/bwireman/dreamy/commit/main)
[![1.2.3](https://img.shields.io/hexpm/v/dreamy?color=brightgreen&style=flat)](https://hexdocs.pm/dreamy/readme.html)
[![downloads](https://img.shields.io/hexpm/dt/dreamy?color=brightgreen)](https://hex.pm/packages/dreamy/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](http://makeapullrequest.com)
![Sick as hell](https://img.shields.io/badge/Sick-as%20hell%20%F0%9F%A4%98-red)

Dreamy provides useful macros & operators to make elixir even more dreamy. 😴

# Operators

- [>>>](https://hexdocs.pm/dreamy/Dreamy.html#%3E%3E%3E/2)
- [~>](https://hexdocs.pm/dreamy/Dreamy.html#~%3E/2)
- [~>>](https://hexdocs.pm/dreamy/Dreamy.html#~%3E%3E/2)

# Macros

- [const](https://hexdocs.pm/dreamy/Dreamy.html#const/2)
- [fallthrough](https://hexdocs.pm/dreamy/Dreamy.html#fallthrough/2)
- [flip](https://hexdocs.pm/dreamy/Dreamy.html#flip/1)
- [otherwise](https://hexdocs.pm/dreamy/Dreamy.html#otherwise/3)
- [through](https://hexdocs.pm/dreamy/Dreamy.html#through/2)
- [unwrap](https://hexdocs.pm/dreamy/Dreamy.html#unwrap/1)
- [unwrap_error](https://hexdocs.pm/dreamy/Dreamy.html#unwrap_error/1)

# Types

- [`nullable(t)`](https://hexdocs.pm/dreamy/Dreamy.Types.html#t:nullable/1)
- [`result(ok, error)`](https://hexdocs.pm/dreamy/Dreamy.Types.html#t:result/2)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dreamy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dreamy, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dreamy](https://hexdocs.pm/dreamy).
