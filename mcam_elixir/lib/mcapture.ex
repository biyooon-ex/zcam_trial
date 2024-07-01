defmodule McamElixir.Mcapture do
  @moduledoc """
  Mcapture module for Mcam
  """

  alias Evision, as: Cv

  @width 500
  @height 282

  @doc """
  Open a camera for video capturing, and connect to a MQTT broker for publish
  """
  def main(ping_topic, cloud_mbroker) do
    # Open a camera and wait 1s to connection
    vs = Cv.VideoCapture.videoCapture(0)
    Process.sleep(1000)

    Tortoise311.Connection.start_link(
      client_id: McamElixir.Mcapture,
      server: {Tortoise311.Transport.Tcp, host: cloud_mbroker, port: 1883},
      handler: {Tortoise311.Handler.Logger, []}
    )

    mpublish(vs, ping_topic)
  end

  # Publish a captured image every 50ms
  defp mpublish(vs, ping_topic) do
    raw = Cv.VideoCapture.read(vs)
    frame = Cv.resize(raw, {@width, @height})
    jpeg = Cv.imencode(".jpg", frame)
    jpg_as_text = Base.encode64(jpeg)

    Tortoise311.publish(McamElixir.Mcapture, ping_topic, jpg_as_text, qos: 0)

    Process.sleep(50)
    mpublish(vs, ping_topic)
  end
end
