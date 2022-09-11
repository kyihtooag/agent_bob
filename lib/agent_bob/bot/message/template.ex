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

  defp prepare_replies({message_type, title, payload}) do
    %{
      "content_type" => "#{message_type}",
      "title" => title,
      "payload" => payload
    }
  end

  defp quick_reply_template(recipient, message) do
    %{
      "message" => message,
      "messaging_type" => "RESPONSE",
      "recipient" => recipient
    }
  end

  def buttons(event, template_title, buttons) do
    buttons = Enum.map(buttons, &prepare_button/1)

    payload = %{
      "template_type" => "button",
      "text" => template_title,
      "buttons" => buttons
    }

    recipient = recipient(event)

    message = %{
      "attachment" => attachment("template", payload)
    }

    template(recipient, message)
  end

  defp prepare_button({message_type, title, payload}) do
    %{
      "type" => "#{message_type}",
      "title" => title,
      "payload" => payload
    }
  end

  defp attachment(type, payload) do
    %{
      "type" => type,
      "payload" => payload
    }
  end

  defp template(recipient, message) do
    %{
      "message" => message,
      "recipient" => recipient
    }
  end

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
