defmodule GalmojiChat.Galmoji.Translator do

  alias GalmojiChat.Galmoji.Dictionary

  def translate(message) do
    message
    |> String.graphemes
    |> Enum.map_join("", fn s -> 
      Dictionary.dict(s)
    end)
  end

end