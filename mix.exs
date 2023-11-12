defmodule Anvil.MixProject do
  use Mix.Project

  @pkg_version "0.1.0"

  def project do
    [
      app: :anvil,
      version: @pkg_version,
      elixir: "~> 1.12",
      deps: deps(),
      aliases: aliases(),
      docs: [
        extras: ["README.md"],
        main: "readme"
      ],
      name: "censys_ex",
      description: description(),
      source_url: "https://github.com/bwireman/censys_ex",
      homepage_url: "https://hexdocs.pm/censys_ex/readme.html",
      package: package(),
    ]
  end

  def application do
    []
  end

  def aliases do
    [
      quality: "do format --check-formatted, credo"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  def description do
    "Set of macros & operators to make Elixir even more dreamy"
  end

  defp package() do
    [
      name: "anvil",
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/bwireman/anvil"
      }
    ]
  end
end
