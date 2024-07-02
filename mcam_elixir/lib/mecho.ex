defmodule McamElixir.Mecho do
  @doc """
  Connect to a MQTT broker for pub/sub
  """

  @client_id Mecho

  def main(ping_topic, pong_topic) do
    Tortoise311.Connection.start_link(
      client_id: @client_id,
      server: {Tortoise311.Transport.Tcp, host: "localhost", port: 1883},
      handler: {McamElixir.Mecho.Handler, [ping_topic: ping_topic, pong_topic: pong_topic, client_id: @client_id]},
      subscriptions: [
        {ping_topic, 0}
      ]
    )
  end
end
