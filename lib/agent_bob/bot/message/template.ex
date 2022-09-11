defmodule AgentBob.Bot.Message.Template do
  @moduledoc """
  Prepares the messages template for reply messages
  """

  alias AgentBob.Bot.Message

  def quick_reply(event, template_title, replies) do
    replies = Enum.map(replies, &prepare_replies/1)

    message = %{
      "text" => template_title,
      "quick_replies" => replies
    }

    recipient = recipient(event)

    quick_reply_template(recipient, message)
  end

  def prepare_replies({message_type, title, payload}) do
    %{
      "content_type" => "#{message_type}",
      "title" => title,
      "payload" => payload
    }
  end

  defp recipient(event) do
    %{"id" => Message.get_sender(event)["id"]}
  end

  defp quick_reply_template(recipient, message) do
    %{
      "message" => message,
      "messaging_type" => "RESPONSE",
      "recipient" => recipient
    }
  end

  def text(event, text) do
    %{
      "recipient" => recipient(event),
      "message" => %{"text" => text}
    }
  end
end
