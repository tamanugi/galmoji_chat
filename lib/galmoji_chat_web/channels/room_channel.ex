defmodule GalmojiChatWeb.RoomChannel do
  use GalmojiChatWeb, :channel
  use Timex

  alias GalmojiChat.Galmoji.Translator

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    %{"username" => username, "message" => message} = payload
    _message = message 
    |> Translator.translate 

    broadcast socket, "shout", %{username: username, message: _message, posted_at: now_string()}
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp now_string() do
    Timex.now("Asia/Tokyo")
    |> Timex.format!("{YYYY}/{0M}/{0D} {h24}:{0m}")
  end
end
