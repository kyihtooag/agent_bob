defmodule AgentBob.Bot.Message.Handler do
  alias AgentBob.Bot
  alias AgentBob.Coingecko
  alias AgentBob.Bot.Message
  alias AgentBob.Bot.Message.Template

  def handle_message(%{"quick_reply" => %{"payload" => coin_id}}, event) do
    coin = Coingecko.get_coin(coin_id)

    coin["id"]
    |> Coingecko.list_market_prices()
    |> Enum.map(fn [date, price] ->
      message = """
        At #{date}, the value of 1 #{coin["name"]} is: $#{price} USD.
      """

      msg_template = Template.text(event, message)
      Bot.send_message(msg_template)
    end)

    message = """
      That's all. If you want to search the other coin, feels free to say 'Hi BoB' or you can select in the menu.
    """

    msg_template = Template.text(event, message)
    Bot.send_message(msg_template)
  end

  def handle_message(%{"text" => text} = message, event) do
    if String.downcase(text) == "hi bob" do
      {:ok, profile} = Message.get_profile(event)
      {:ok, first_name} = Map.fetch(profile, "first_name")

      message = "Hello #{first_name}!"
      message_template = Template.text(event, message)

      Bot.send_message(message_template)
      search_by_message(event)
    else
      handle_message(message, event)
    end
  end

  def handle_message(_message, event) do
    greetings = Message.greet()

    message = """
    #{greetings}

    Unknown Message Received
    """

    msg_template = Template.text(event, message)
    Bot.send_message(msg_template)
  end

  def handle_postback(%{"payload" => "by_id"}, event) do
    replies =
      Coingecko.list_coin()
      |> Enum.map(fn coin ->
        {:text, coin["id"], coin["id"]}
      end)

    template_title = "Which coin do you like to search?"

    event
    |> Template.quick_reply(template_title, replies)
    |> Bot.send_message()
  end

  def handle_postback(%{"payload" => "by_name"}, event) do
    replies =
      Coingecko.list_coin()
      |> Enum.map(fn coin ->
        {:text, coin["name"], coin["id"]}
      end)

    template_title = "Which coin do you like to search?"

    event
    |> Template.quick_reply(template_title, replies)
    |> Bot.send_message()
  end

  defp search_by_message(event) do
    buttons = [
      {:postback, "By Coin ID", "by_id"},
      {:postback, "By Coin Name", "by_name"}
    ]

    template_title = "How would you like to search coin with?"
    color_template = Template.buttons(event, template_title, buttons)

    Bot.send_message(color_template)
  end
end
