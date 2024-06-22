defmodule ZcamElixir.Zecho do
  @moduledoc """
  Zcapture module for Zcam
  """

  @doc """
  Open a Zenoh session for echo (subscribe and publish)
  """
  def main(ping_key, pong_key) do
    # Open a Zenoh session for subscribe
    {:ok, session} = Zenohex.open()
    {:ok, subscriber} = Zenohex.Session.declare_subscriber(session, ping_key)

    # Open a Zenoh session for publish
    {:ok, session} = Zenohex.open()
    {:ok, publisher} = Zenohex.Session.declare_publisher(session, pong_key)

    frames_listener(subscriber, publisher)
  end

  # echo a captured image (subscribe it, and then put directly)
  defp frames_listener(subscriber, publisher) do
    case Zenohex.Subscriber.recv_timeout(subscriber) do
      {:ok, sample} -> Zenohex.Publisher.put(publisher, sample.value)
      {:error, :timeout} -> nil
    end

    Process.sleep(50)
    frames_listener(subscriber, publisher)
  end
end
