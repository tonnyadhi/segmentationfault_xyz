defmodule SegmentationFaultSite.MixFile do
  use Mix.Project

  def project do
    [
      app: :segmentation_fault_site,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:serum]
    ]
  end

  defp deps do
    [
      {:serum, "~> 1.5"},
      {:serum_theme_essence, "~> 1.0"},
      #{:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
