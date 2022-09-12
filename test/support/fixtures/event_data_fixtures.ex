defmodule AgentBob.EventDataFixtures do
  def build_text_message(message) do
    recipient_id = gen_id()
    sender_id = gen_id()

    %{
      "message" => %{
        "text" => message
      },
      "recipient" => %{"id" => "#{recipient_id}"},
      "sender" => %{"id" => "#{sender_id}"},
      "timestamp" => now_timestamp()
    }
    |> do_build_event_data(recipient_id)
  end

  def build_quick_reply_message(coin) do
    recipient_id = gen_id()
    sender_id = gen_id()

    %{
      "message" => %{
        "quick_reply" => %{"payload" => coin},
        "text" => coin
      },
      "recipient" => %{"id" => "#{recipient_id}"},
      "sender" => %{"id" => "#{sender_id}"},
      "timestamp" => now_timestamp()
    }
    |> do_build_event_data(recipient_id)
  end

  def build_postback_message(%{"payload" => payload, "title" => title}) do
    recipient_id = gen_id()
    sender_id = gen_id()

    %{
      "postback" => %{
        "payload" => payload,
        "title" => title
      },
      "recipient" => %{"id" => "#{recipient_id}"},
      "sender" => %{"id" => "#{sender_id}"},
      "timestamp" => now_timestamp()
    }
    |> do_build_event_data(recipient_id)
  end

  defp do_build_event_data(message, recipient_id) do
    %{
      "entry" => [
        %{
          "id" => "#{recipient_id}",
          "messaging" => [
            message
          ],
          "time" => now_timestamp()
        }
      ],
      "object" => "page"
    }
  end

  defp now_timestamp(), do: DateTime.utc_now() |> DateTime.to_unix(:millisecond)

  defp gen_id(), do: Enum.random(1_000_000_000..9_999_999_999)
end
