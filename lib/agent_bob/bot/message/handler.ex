defmodule AgentBob.Bot.Message.Handler do
  alias AgentBob.Bot
  alias AgentBob.Coingecko
  alias AgentBob.Bot.Message
  alias AgentBob.Bot.Message.Template

  def handle_message(%{"text" => "hi"}, event) do
    {:ok, profile} = Message.get_profile(event)
    {:ok, first_name} = Map.fetch(profile, "first_name")
    message = "Hello #{first_name}!"
    resp_template = Template.text(event, message)
    Bot.send_message(resp_template)
  end

  def handle_message(_message, event) do
    greetings = Message.greet()

    message = """
    #{greetings}

    Unknown Message Received :>
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
end
