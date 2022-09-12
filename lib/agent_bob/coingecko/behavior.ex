defmodule AgentBob.Coingecko.Behavior do
  @callback get_coin(String.t()) :: {:ok, map()} | :error
  @callback list_coin() :: {:ok, List.t()} | :error
  @callback list_market_prices(String.t()) :: {:ok, List.t()} | :error
end
