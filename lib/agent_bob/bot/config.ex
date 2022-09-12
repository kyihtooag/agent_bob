defmodule AgentBob.Bot.Config do
  @moduledoc """
  The context module of configuration related to Facebook ChatBot Client.
  """

  def page_access_token do
    Map.get(config(), :page_access_token)
  end

  def webhook_verify_token do
    Map.get(config(), :webhook_verify_token)
  end

  def message_url() do
    bot_config = config()
    page_token = bot_config.page_access_token
    message_url = bot_config.message_url
    base_url = bot_config.base_url
    version = bot_config.api_version
    token_path = "?access_token=#{page_token}"
    Path.join([base_url, version, message_url, token_path])
  end

  def messenger_profile_url() do
    bot_config = config()
    page_token = bot_config.page_access_token
    messenger_profile_url = bot_config.messenger_profile_url
    base_url = bot_config.base_url
    version = bot_config.api_version
    token_path = "?access_token=#{page_token}"
    Path.join([base_url, version, messenger_profile_url, token_path])
  end

  def config do
    Application.get_env(:agent_bob, :chat_bot)
  end
end
