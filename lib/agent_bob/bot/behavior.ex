defmodule AgentBob.Bot.Behavior do
  @callback verify_webhook(map()) :: boolean
  @callback get_profile(map()) :: {:ok, map()} | {:enoprofile, :error}
  @callback setup_bot() :: :ok | :error
  @callback send_message(List.t() | map()) :: :ok | :error
end
