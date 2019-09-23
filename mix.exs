defmodule GuardianPhoenix.MixProject do
  use Mix.Project

  @name :guardian_phoenix
  @version "2.0.1"
  @elixir_version "~> 1.7"
  @source_url "https://github.com/ueberauth/guardian_phoenix"

  def project do
    production? = Mix.env() == :prod

    [
      app: @name,
      version: @version,
      elixir: @elixir_version,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      build_embedded: production?,
      start_permanent: production?,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls.html": :test,
        "coveralls.json": :test
      ],
      xref: [exclude: [:phoenix]],
      dialyzer: [
        plt_add_deps: :transitive,
        plt_add_apps: [:mix],
        flags: [:race_conditions, :no_opaque]
      ],

      # Hex
      description: "Guardian & Phoenix integration",
      package: package(),

      # Docs
      name: "Guardian.Phoenix",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:guardian, "~> 2.0"},
      {:phoenix, "~> 1.3"},

      # Test
      {:jason, "~> 1.1", only: [:dev, :test], runtime: false},

      # Tools
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 1.0.0-rc4", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:excoveralls, ">= 0.0.0", only: [:test], runtime: false},
      {:inch_ex, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      name: @name,
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      maintainers: [
        "Daniel Neighman",
        "Sonny Scroggin",
        "Sean Callan",
        "Yordis Prieto"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
