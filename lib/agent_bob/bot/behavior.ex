defmodule AgentBob.Bot.Behavior do
  @callback verify_webhook(map()) :: boolean
  @callback setup_bot() :: :ok | :error
  @callback handle_events(map()) :: :ok | :error
  @callback send_message(map()) :: :ok | :error
end
