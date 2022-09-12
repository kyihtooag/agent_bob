defmodule AgentBob.BotImpl do
  @moduledoc """
  The implementation for the Facebook Chatbot Client.
  """

  require Logger

  @behaviour AgentBob.Bot.Behavior

  alias AgentBob.Bot.{Config, MessageTemplate}

  # Verifies the request params of faceboo, webhook mode and token.
  # If both of them are matche, returns true. If not, returns false.
  @impl true
  def verify_webhook(params) do
    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == Config.webhook_verify_token()
  end

  @impl true
  def get_profile(event) do
    sender = MessageTemplate.get_sender(event)
    bot_config = Config.config()
    page_token = bot_config.page_access_token
    base_url = bot_config.base_url
    version = bot_config.api_version
    token_path = "?access_token=#{page_token}"
    profile_path = Path.join([base_url, version, sender["id"], token_path])

    case HTTPoison.get(profile_path) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, _error} ->
        {:enoprofile, :error}
    end
  end

  @impl true
  def send_message(msg_template) when is_list(msg_template),
    do: Enum.each(msg_template, &send_message(&1))

  @impl true
  def send_message(msg_template) do
    message_url = Config.message_url()
    Logger.info(message_url)
    headers = [{"content-type", "application/json"}]
    msg_template = Jason.encode!(msg_template)

    case HTTPoison.post(message_url, msg_template, headers) do
      {:ok, _response} ->
        Logger.info("Message Sent to Bot")
        :ok

      {:error, reason} ->
        Logger.error("Error in sending message to bot, #{inspect(reason)}")
        :error
    end
  end

  @impl true
  def setup_bot() do
    messenger_profile_url = Config.messenger_profile_url()
    Logger.info(messenger_profile_url)
    headers = [{"content-type", "application/json"}]

    body =
      %{
        "get_started" => %{
          "payload" => "Hi, I'm a bot"
        },
        "greeting" => [
          %{
            "locale" => "default",
            "text" => "
            Hi {{user_first_name}}! I'm Agent Bob. I can search you the market price of any coin for the last 14 days records.
          "
          }
        ],
        "ice_breakers" => [
          %{
            "call_to_actions" => [
              %{
                "question" => "Coin ID",
                "payload" => "by_id"
              },
              %{
                "question" => "Coin Name",
                "payload" => "by_name"
              }
            ],
            "locale" => "default"
          }
        ],
        "persistent_menu" => [
          %{
            "locale" => "default",
            "composer_input_disabled" => false,
            "call_to_actions" => [
              %{
                "type" => "postback",
                "title" => "Search coin by ID",
                "payload" => "by_id"
              },
              %{
                "type" => "postback",
                "title" => "Search coin by name",
                "payload" => "by_name"
              }
            ]
          }
        ]
      }
      |> Jason.encode!()

    case HTTPoison.post(messenger_profile_url, body, headers) do
      {:ok, _response} ->
        Logger.info("Successfully setup messenger profile.")
        :ok

      {:error, reason} ->
        Logger.error("Error in setting up messenger profile, #{inspect(reason)}")
        :error
    end
  end
end
