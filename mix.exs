defmodule Dreamy.MixProject do
  use Mix.Project

  @pkg_version "0.3.0"

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
      dialyzer: dialyzer(),
      test_coverage: coverage()
    ]
  end

  def application, do: []

  def aliases,
    do: [
      quality:
        "do clean, compile --warnings-as-errors, format --check-formatted, dialyzer, credo --strict"
    ]

  # Run "mix help deps" to learn about dependencies.
  defp deps,
    do: [
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:committee, "~> 1.0.0", only: :dev, runtime: false},
      {:file_system, "~> 1.0.0", only: [:dev, :test], override: true},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false}
    ]

  defp dialyzer,
    do: [
      flags: ["-Wunmatched_returns", :error_handling, :underspecs]
    ]

  def coverage, do: [ignore_modules: [Checks.RejectAny], summary: [threshold: 99]]

  def description,
    do:
      "Dreamy provides useful macros, functions, types & operators to make elixir even dreamier 😴"

  defp package,
    do: [
      name: "dreamy",
      licenses: ["MIT"],
      files: ~w(lib/dreamy.ex lib/dreamy/ .formatter.exs mix.exs README* LICENSE*),
      links: %{
        "Github" => "https://github.com/bwireman/dreamy"
      }
    ]
end
