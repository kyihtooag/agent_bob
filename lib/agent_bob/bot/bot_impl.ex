defmodule AgentBob.BotImpl do
  @moduledoc """
  The implementation for the chat bot behaviors.
  """
  @behaviour AgentBob.Bot.Behavior

  require Logger

  alias AgentBob.Bot.{Config, Message}
  alias AgentBob.Bot.Message.{Handler, Template}

  # Verifies the request params of faceboo, webhook mode and token.
  # If both of them are matche, returns true. If not, returns false.
  @impl true
  def verify_webhook(params) do
    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == Config.webhook_verify_token()
  end

  def handle_events(event) do
    case Message.get_messaging(event) do
      %{"message" => message} ->
        Handler.handle_message(message, event)

      %{"postback" => postback} ->
        Handler.handle_postback(postback, event)

      _ ->
        error_template =
          Template.text(event, "Something went wrong. Our Engineers are working on it.")

        send_message(error_template)
    end
  end

  @spec send_message(map()) :: :ok | :error
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
