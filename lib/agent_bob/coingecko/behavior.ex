defmodule AgentBob.Coingecko.Behavior do
  @moduledoc """
  The client module behaviors for interacting wtih Coingecko API.
  """

  @callback get_coin(String.t()) :: {:ok, map()} | :error
  @callback list_coin() :: {:ok, List.t()} | :error
  @callback list_market_prices(String.t()) :: {:ok, List.t()} | :error
end
