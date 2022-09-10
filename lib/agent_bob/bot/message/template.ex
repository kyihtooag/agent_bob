defmodule AgentBob.Bot.Message.Template do
  alias AgentBob.Bot.Message

  defp recipient(event) do
    %{"id" => Message.get_sender(event)["id"]}
  end

  def text(event, text) do
    %{
      "recipient" => recipient(event),
      "message" => %{"text" => text}
    }
  end
end
