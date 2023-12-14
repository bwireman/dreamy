defmodule Dreamy.MixProject do
  use Mix.Project

  @pkg_version "0.2.1"

  def project do
    [
      app: :dreamy,
      version: @pkg_version,
      elixir: "~> 1.12",
      deps: deps(),
      aliases: aliases(),
      docs: [
        extras: ["README.md"],
        main: "readme"
      ],
      name: "dreamy",
      description: description(),
      source_url: "https://github.com/bwireman/dreamy",
      homepage_url: "https://hexdocs.pm/dreamy/readme.html",
      package: package(),
      dialyzer: dialyzer()
    ]
  end

  def application do
    []
  end

  def aliases do
    [
      quality:
        "do clean, compile --warnings-as-errors, format --check-formatted, dialyzer, credo --strict"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer() do
    [
      flags: ["-Wunmatched_returns", :error_handling, :underspecs]
    ]
  end

  def description do
    "Dreamy provides useful macros, functions, types & operators to make elixir even dreamier 😴"
  end

  defp package() do
    [
      name: "dreamy",
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/bwireman/dreamy"
      }
    ]
  end
end
