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

end
