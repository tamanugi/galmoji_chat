# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :galmoji_chat,
  ecto_repos: [GalmojiChat.Repo]

# Configures the endpoint
config :galmoji_chat, GalmojiChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vJnvr2i+Phnt5ei4Hg8go6u6dJbz4t4BAcgSxoZSyt3SdY93CZnwsKVzezE/K50u",
  render_errors: [view: GalmojiChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GalmojiChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
