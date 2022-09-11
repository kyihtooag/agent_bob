defmodule AgentBob.Coingecko do
  def get_coin(coin_id) do
    coingecko_impl().get_coin(coin_id)
  end

  def list_coin() do
    coingecko_impl().list_coin
  end

  def list_market_prices(coin_id) do
    coingecko_impl().list_market_prices(coin_id)
  end

  defp coingecko_impl() do
    Application.get_env(:agent_bob, :coingecko, AgentBob.CoingeckoImpl)
  end
end
