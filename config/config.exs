# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :agent_bob, AgentBobWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: AgentBobWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AgentBob.PubSub,
  live_view: [signing_salt: "okvUgABf"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :agent_bob, AgentBob.Mailer, adapter: Swoosh.Adapters.Local

config :agent_bob,
  chat_bot: %{
    message_url: "me/messages",
    messenger_profile_url: "me/messenger_profile",
    api_version: "v13.0",
    base_url: "https://graph.facebook.com",
    page_access_token: System.fetch_env!("FACEBOOK_PAGE_ACCESS_TOKEN"),
    webhook_verify_token: System.fetch_env!("FACEBOOK_WEBHOOK_VERIFY_TOKEN")
  },
  coingecko_api: %{
    base_url: "https://api.coingecko.com/api/v3",
    list_url: "/coins/list"
  }

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
