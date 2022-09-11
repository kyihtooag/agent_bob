defmodule AgentBob.Coingecko.Behavior do
  @callback get_coin(String.t()) :: map() | :error
  @callback list_coin() :: List.t() | :error
  @callback list_market_prices(String.t()) :: List.t() | :error
end
