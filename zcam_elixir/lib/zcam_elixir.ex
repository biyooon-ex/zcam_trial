defmodule ZcamElixir do
  @moduledoc """
  Main module for Elixir version of Zcam
  """

  @ping_key "demo/zcam/ping"
  @pong_key "demo/zcam/pong"

  @doc """
  Call Zcapture.

  ## Examples

      iex> ZcamElixir.zcapture
      iex> ZcamElixir.zcapture("demo/zcam/ping")
  """
  def zcapture(ping_key \\ @ping_key) do
    ZcamElixir.Zcapture.main(ping_key)
  end

  @doc """
  Call Zecho.

  ## Examples

      iex> ZcamElixir.zecho
      iex> ZcamElixir.zecho("demo/zcam/ping", "demo/zcam/pong")
  """
  def zecho(ping_key \\ @ping_key, pong_key \\ @pong_key) do
    ZcamElixir.Zecho.main(ping_key, pong_key)
  end
end
