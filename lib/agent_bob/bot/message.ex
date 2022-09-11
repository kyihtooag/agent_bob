defmodule AgentBob.Bot.Message do
  alias AgentBob.Bot.Config

  def get_sender(event) do
    messaging = get_messaging(event)
    messaging["sender"]
  end

  def get_messaging(event) do
    [entry | _any] = event["entry"]
    [messaging | _any] = entry["messaging"]
    messaging
  end

  def get_profile(event) do
    sender = get_sender(event)
    bot_config = Config.config()
    page_token = bot_config.page_access_token
    base_url = bot_config.base_url
    version = bot_config.api_version
    token_path = "?access_token=#{page_token}"
    profile_path = Path.join([base_url, version, sender["id"], token_path])

    case HTTPoison.get(profile_path) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, error} ->
        {:enoprofile, error}
    end
  end

  def greet() do
    """
    Hello buddy :)
    Welcome to BoB
    """
  end
end
