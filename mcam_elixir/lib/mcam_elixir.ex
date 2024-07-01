defmodule McamElixir do
  @moduledoc """
  Main module for Elixir version of Mcam
  """

  @ping_topic "demo/mcam/ping"
  @pong_topic "demo/mcam/pong"

  @doc """
  Call Mcapture.

  ## Examples

      iex> McamElixir.mcapture
      iex> McamElixir.mcapture("demo/mcam/ping")
  """
  def mcapture(ping_topic \\ @ping_topic, cloud_mbroker \\ "localhost") do
    IO.puts(cloud_mbroker)
    McamElixir.Mcapture.main(ping_topic, cloud_mbroker)
  end

  @doc """
  Call Mecho.

  ## Examples

      iex> McamElixir.mecho
      iex> McamElixir.mecho("demo/mcam/ping", "demo/mcam/pong")
  """
  def mecho(ping_topic \\ @ping_topic, pong_topic \\ @pong_topic) do
    McamElixir.Mecho.main(ping_topic, pong_topic)
  end
end
