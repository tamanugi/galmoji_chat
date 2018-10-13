defmodule GalmojiChatWeb.PageController do
  use GalmojiChatWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
