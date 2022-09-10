defmodule AgentBob.Bot do
  @moduledoc """
  The Interface module for the every modules related Chat Bot
  """
  require Logger

  alias AgentBob.Bot.{Config, Message}
  alias AgentBob.Bot.Message.{Handler, Template}

  @bot_config Config.config()

  # Verifies the request params of faceboo, webhook mode and token.
  # If both of them are matche, returns true. If not, returns false.
  @spec verify_webhook(map()) :: boolean
  def verify_webhook(params) do
    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == Config.webhook_verify_token()
  end

  def handle_events(event) do
    case Message.get_messaging(event) do
      %{"message" => message} ->
        Handler.handle_message(message, event)

      _ ->
        error_template =
          Template.text(event, "Something went wrong. Our Engineers are working on it.")

        send_message(error_template)
    end
  end

  @spec send_message(map()) :: :ok | :error
  def send_message(msg_template) do
    endpoint = bot_endpoint()
    Logger.info(endpoint)
    headers = [{"content-type", "application/json"}]
    msg_template = Jason.encode!(msg_template)

    case HTTPoison.post(endpoint, msg_template, headers) do
      {:ok, _response} ->
        Logger.info("Message Sent to Bot")
        :ok

      {:error, reason} ->
        Logger.error("Error in sending message to bot, #{inspect(reason)}")
        :error
    end
  end

  defp bot_endpoint() do
    page_token = @bot_config.page_access_token
    message_url = @bot_config.message_url
    base_url = @bot_config.base_url
    version = @bot_config.api_version
    token_path = "?access_token=#{page_token}"
    Path.join([base_url, version, message_url, token_path])
  end
end
