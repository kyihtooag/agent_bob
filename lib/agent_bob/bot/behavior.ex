defmodule AgentBob.Bot.Behavior do
  @moduledoc """
  The client module behaviors for interacting wtih Facebook Chatbot.
  """

  @callback verify_webhook(map()) :: boolean
  @callback get_profile(map()) :: {:ok, map()} | {:enoprofile, :error}
  @callback setup_bot() :: :ok | :error
  @callback send_message(List.t() | map()) :: :ok | :error
end
