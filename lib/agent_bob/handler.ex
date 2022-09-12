defmodule AgentBob.Handler do
  @moduledoc """
  The context module for handling all the events received from Facebook ChatBot.
  """

  alias AgentBob.Bot
  alias AgentBob.Coingecko
  alias AgentBob.Bot.MessageTemplate

  def handle_events(event) do
    case MessageTemplate.get_messaging(event) do
      %{"message" => message} ->
        handle_message(message, event)

      %{"postback" => postback} ->
        handle_postback(postback, event)

      _ ->
        MessageTemplate.text(event, "Something went wrong. Our Engineers are working on it.")
    end
  end

  defp handle_message(%{"quick_reply" => %{"payload" => coin_id}}, event) do
    with {:ok, coin} <- Coingecko.get_coin(coin_id),
         {:ok, prices_list} <- Coingecko.list_market_prices(coin["id"]) do
      prices_list
      |> Enum.map(fn [date, price] ->
        message = """
          At #{date}, the value of 1 #{coin["name"]} is: $#{price} USD.
        """

        MessageTemplate.text(event, message)
      end)
      |> List.insert_at(-1, intruction_message(event))
    else
      _ ->
        MessageTemplate.text(event, "Something went wrong. Our Engineers are working on it.")
    end
  end

  defp handle_message(%{"text" => text}, event) do
    if String.downcase(text) == "hi bob" do
      {:ok, profile} = Bot.get_profile(event)
      {:ok, first_name} = Map.fetch(profile, "first_name")

      message = "Hello #{first_name}!"

      [
        MessageTemplate.text(event, message),
        search_by_message(event)
      ]
    else
      greeting_message(event)
    end
  end

  defp handle_postback(%{"payload" => "by_id"}, event) do
    case Coingecko.list_coin() do
      {:ok, prices_list} ->
        replies =
          prices_list
          |> Enum.map(fn coin ->
            {:text, coin["id"], coin["id"]}
          end)

        template_title = "Which coin do you like to search?"

        event
        |> MessageTemplate.quick_reply(template_title, replies)

      :error ->
        MessageTemplate.text(event, "Something went wrong. Our Engineers are working on it.")
    end
  end

  defp handle_postback(%{"payload" => "by_name"}, event) do
    case Coingecko.list_coin() do
      {:ok, prices_list} ->
        replies =
          prices_list
          |> Enum.map(fn coin ->
            {:text, coin["name"], coin["id"]}
          end)

        template_title = "Which coin do you like to search?"

        event
        |> MessageTemplate.quick_reply(template_title, replies)

      :error ->
        MessageTemplate.text(event, "Something went wrong. Our Engineers are working on it.")
    end
  end

  defp greeting_message(event) do
    message = """
    Hello!I'm BoB.
    Say 'Hi BoB' or select in the menu if you want to search.
    """

    MessageTemplate.text(event, message)
  end

  defp intruction_message(event) do
    message = """
    That's all. If you want to search the other coin, feels free to say 'Hi BoB' or you can select in the menu.
    """

    MessageTemplate.text(event, message)
  end

  defp search_by_message(event) do
    buttons = [
      {:postback, "By Coin ID", "by_id"},
      {:postback, "By Coin Name", "by_name"}
    ]

    template_title = "How would you like to search coin with?"
    MessageTemplate.buttons(event, template_title, buttons)
  end
end
