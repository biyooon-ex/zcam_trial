defmodule ZcamElixir.Zcapture do
  @moduledoc """
  Zcapture module for Zcam
  """

  alias Evision, as: Cv

  @width 500
  @height 282

  @doc """
  Open a camera for video capturing, and a Zenoh session for publish
  """
  def main(ping_key) do
    # Open a camera and wait 1s to connection
    vs = Cv.VideoCapture.videoCapture(0)
    Process.sleep(1000)

    # Open a Zenoh session for publish
    {:ok, session} = Zenohex.open()
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
