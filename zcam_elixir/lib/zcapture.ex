defmodule ZcamElixir.Zcapture do
  @moduledoc """
  Zcapture module for Zcam
  """

  alias Evision, as: Cv

  @width 500
  @height 282

  alias Zenohex.Config
  alias Zenohex.Config.Connect
  alias Zenohex.Config.Scouting

  @doc """
  Open a camera for video capturing, and a Zenoh session for publish
  """
  def main(ping_key, cloud_zenohd) do
    # Open a camera and wait 1s to connection
    vs = Cv.VideoCapture.videoCapture(0)
    Process.sleep(1000)

    # Config Zenoh router on a cloud when specified
    config =
      case cloud_zenohd do
        nil ->
          %Config{}

        _ ->
          %Config{
            connect: %Connect{endpoints: [cloud_zenohd]},
            scouting: %Scouting{delay: 200}
          }
      end

    # Open a Zenoh session for publish
    {:ok, session} = Zenohex.open(config)
    {:ok, publisher} = Zenohex.Session.declare_publisher(session, ping_key)

    zput(vs, publisher)
  end

  # Put (publish) a captured image every 50ms
  defp zput(vs, publisher) do
    raw = Cv.VideoCapture.read(vs)
    frame = Cv.resize(raw, {@width, @height})
    jpeg = Cv.imencode(".jpg", frame)

    Zenohex.Publisher.put(publisher, jpeg)

    Process.sleep(50)
    zput(vs, publisher)
  end
end
