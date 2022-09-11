defmodule AgentBob.Coingecko do
  require Logger

  alias Decimal

  @config Application.get_env(:agent_bob, :coingecko)
  @headers [{"content-type", "application/json"}]

  def list_coin do
    request_url = Path.join(@config.base_url, @config.list_url)

    with {:ok, %{body: body}} <- HTTPoison.get(request_url, @headers),
         {:ok, coins_list} <- Jason.decode(body) do
      Enum.take_random(coins_list, 5)
    else
      {:error, _} ->
        Logger.error("Error in requesting coin list from coingecko.")
        :error
    end
  end

  def list_market_prices(coin_id) do
    request_params = "/coins/#{coin_id}/market_chart?vs_currency=usd&days=14&interval=daily"
    request_url = Path.join(@config.base_url, request_params)

    with {:ok, %{body: body}} <- HTTPoison.get(request_url, @headers),
         {:ok, response} <- Jason.decode(body) do
      response["prices"]
      |> Enum.map(fn [timestamp, price] ->
        [
          timestamp |> DateTime.from_unix!(:millisecond) |> DateTime.to_date(),
          price |> Decimal.from_float() |> Decimal.round(6)
        ]
      end)
      # by requestiing the market chart data of the coin using daily interval will give two market price of the current day, openning price and current price. So, we will neglect the current price.
      |> List.delete_at(-1)
    else
      {:error, _} ->
        Logger.error("Error in requesting coin list from coingecko.")
        :error
    end
  end
end
