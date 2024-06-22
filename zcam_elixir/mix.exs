defmodule ZcamElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :zcam_elixir,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:zenohex, "~> 0.2.0"},
      {:zenohex, path: "../../zenohex", override: true},
      {:rustler, ">= 0.0.0", optional: true},
      {:evision, "~> 0.2"}
    ]
  end
end
