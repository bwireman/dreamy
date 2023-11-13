# Dreamy 😴

[![ci](https://github.com/bwireman/dreamy/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/bwireman/dreamy/actions/workflows/elixir.yml)
[![mit](https://img.shields.io/github/license/bwireman/dreamy?color=brightgreen)](https://github.com/bwireman/dreamy/blob/main/LICENSE)
[![commits](https://img.shields.io/github/last-commit/bwireman/dreamy)](https://github.com/bwireman/dreamy/commit/main)
[![0.1.3](https://img.shields.io/hexpm/v/dreamy?color=brightgreen&style=flat)](https://hexdocs.pm/dreamy/readme.html)
[![downloads](https://img.shields.io/hexpm/dt/dreamy?color=brightgreen)](https://hex.pm/packages/dreamy/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](http://makeapullrequest.com)
![Dreamy 😴](https://img.shields.io/badge/Dreamy%20%F0%9F%98%B4-blue)

Dreamy provides useful macros, functions, types & operators to make elixir even more dreamy 😴

# Operators

- [>>>](https://hexdocs.pm/dreamy/Dreamy.html#%3E%3E%3E/2)
- [~>](https://hexdocs.pm/dreamy/Dreamy.html#~%3E/2)
- [~>>](https://hexdocs.pm/dreamy/Dreamy.html#~%3E%3E/2)

# Macros

- [fallthrough](https://hexdocs.pm/dreamy/Dreamy.html#fallthrough/2)
- [otherwise](https://hexdocs.pm/dreamy/Dreamy.html#otherwise/3)
- [const](https://hexdocs.pm/dreamy/Dreamy.html#const/2)

# Functions

- [through](https://hexdocs.pm/dreamy/Dreamy.html#through/2)
- [unwrap](https://hexdocs.pm/dreamy/Dreamy.html#unwrap/1)
- [unwrap_error](https://hexdocs.pm/dreamy/Dreamy.html#unwrap_error/1)
- [flip](https://hexdocs.pm/dreamy/Dreamy.html#flip/1)

# Types

- [`nullable(t)`](https://hexdocs.pm/dreamy/Dreamy.Types.html#t:nullable/1)
- [`result(ok, error)`](https://hexdocs.pm/dreamy/Dreamy.Types.html#t:result/2)

## Installation

[Available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dreamy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dreamy, "~> 0.1.3"}
  ]
end
```