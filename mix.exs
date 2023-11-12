defmodule Dreamy.MixProject do
  use Mix.Project

  @pkg_version "0.1.0"

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
      package: package()
    ]
  end

  def application do
    []
  end

  def aliases do
    [
      quality: "do clean, compile --warnings-as-errors, format --check-formatted, credo"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  def description do
    "Set of macros & operators to make Elixir even more dreamy"
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
