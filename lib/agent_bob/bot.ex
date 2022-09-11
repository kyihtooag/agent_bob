defmodule AgentBob.Bot do
  def setup_bot() do
    bot_impl().setup_bot
  end

  def verify_webhook(params) do
    bot_impl().verify_webhook(params)
  end

  def handle_events(event) do
    bot_impl().handle_events(event)
  end

  def send_message(msg_template) do
    bot_impl().send_message(msg_template)
  end

  defp bot_impl() do
    Application.get_env(:agent_bob, :bot, AgentBob.BotImpl)
  end
end
