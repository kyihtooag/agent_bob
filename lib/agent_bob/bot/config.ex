defmodule AgentBob.Bot.Config do
  def api_version do
    Map.get(config(), :api_version)
  end

  def base_url do
    Map.get(config(), :base_url)
  end

  def message_url do
    Map.get(config(), :message_url)
  end

  def page_access_token do
    Map.get(config(), :page_access_token)
  end

  def webhook_verify_token do
    Map.get(config(), :webhook_verify_token)
  end

  def config do
    Application.get_env(:agent_bob, :chat_bot)
  end
end
