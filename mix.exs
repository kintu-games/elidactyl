defmodule Elidactyl.MixProject do
  use Mix.Project

  def project do
    [
      app: :elidactyl,
      version: "0.5.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env),
      description: "Elixir API for Pterodactyl game panel",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Elidactyl.Application, [env: Mix.env]},
#      applications: applications(Mix.env),
      extra_applications: [:logger],
      dialyzer: [
        plt_add_deps: :apps_direct,
        paths: ["_build/dev/lib/plug/ebin"]
      ]
    ]
  end

#  defp applications(:test), do: applications(:default) ++ [:cowboy, :plug, :myxql]
#  defp applications(_),     do: [:logger, :httpoison, :myxql]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"},
      {:observer_cli, "~> 1.5"},
      {:ecto_sql, ">= 0.0.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Roman Berdichevskii"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/kintull/elidactyl"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib","test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
