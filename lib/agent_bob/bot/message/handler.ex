defmodule AgentBob.Bot.Message.Handler do
  alias AgentBob.Bot
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
end
