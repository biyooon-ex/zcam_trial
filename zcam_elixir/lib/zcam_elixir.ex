defmodule ZcamElixir do
  @moduledoc """
  Main module for Elixir version of Zcam
  """

  @ping_key "demo/zcam/ping"

  @doc """
  Call Zcapture.

  ## Examples

      iex> ZcamElixir.zcapture
      iex> ZcamElixir.zcapture("demo/zcam/ping")
  """
  def zcapture do
    zcapture(@ping_key)
  end

  def zcapture(ping_key) do
    ZcamElixir.Zcapture.main(ping_key)
  end
end
