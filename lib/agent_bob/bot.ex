defmodule AgentBob.Bot do
  @moduledoc """
  The Interface module for the every modules related Chat Bot
  """
  require Logger

  @spec verify_webhook(map()) :: boolean
  def verify_webhook(params) do
    chat_bot = Application.get_env(:agent_bob, :chat_bot)
    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == chat_bot.webhook_verify_token
  end
end
