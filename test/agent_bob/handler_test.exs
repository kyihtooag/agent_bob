defmodule AgentBob.HandlerTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import AgentBob.EventDataFixtures
  import Mox

  alias AgentBob.Handler

  require ExUnitProperties

  setup :verify_on_exit!

  describe "handle_events/1, replies to customer according to the message events" do
    test "replies greeting message along with instruction if the customer sends the unrecognised message" do
      event = build_text_message("Hi")

      event
      |> Handler.handle_events()
      |> assert_text_message
    end

    test "replies selection message if the customer sends 'Hi Bob' regardless of case" do
      check all(message <- StreamData.member_of(["HI BOB", "hi bob", "Hi Bob"])) do
        AgentBob.BotMock
        |> expect(:get_profile, fn _ -> {:ok, %{"first_name" => "Joe"}} end)

        message
        |> build_text_message()
        |> Handler.handle_events()
        |> assert_selection_message
      end
    end

    test "replies list of quick replies if the customer select either 'Search by ID' or 'Search by Name'" do
      possible_postback = [
        %{"payload" => "by_id", "title" => "By Coin ID"},
        %{"payload" => "by_name", "title" => "By Coin Name"}
      ]

      check all(message <- StreamData.member_of(possible_postback)) do
        AgentBob.CoingeckoMock
        |> expect(:list_coin, fn ->
          {:ok,
           [
             %{"name" => "bitcoin", "id" => "bitcoin"},
             %{"name" => "ethereum", "id" => "ethereum"}
           ]}
        end)

        message
        |> build_postback_message()
        |> Handler.handle_events()
        |> assert_quick_reply_message()
      end
    end

    test "replies list of prices of the coin that customer searched along with instruction message" do
      date_1 = DateTime.utc_now() |> DateTime.add(-1) |> DateTime.to_unix(:millisecond)
      date_2 = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
      price_1 = (:rand.uniform() * 10) |> Float.round(6)
      price_2 = (:rand.uniform() * 10) |> Float.round(6)
      event = build_quick_reply_message("bitcoin")

      AgentBob.CoingeckoMock
      |> expect(:get_coin, fn _ -> {:ok, %{"name" => "bitcoin", "id" => "bitcoin"}} end)
      |> expect(:list_market_prices, fn _ ->
        {:ok,
         [
           [date_1, price_1],
           [date_2, price_2]
         ]}
      end)

      event
      |> Handler.handle_events()
      |> assert_pirce_list_message
    end

    test "replies error message if there was an error during retrieving data from coingecko" do
      event = build_quick_reply_message("bitcoin")

      AgentBob.CoingeckoMock
      |> expect(:get_coin, fn _ -> {:ok, %{"name" => "bitcoin", "id" => "bitcoin"}} end)
      |> expect(:list_market_prices, fn _ ->
        :error
      end)

      event
      |> Handler.handle_events()
      |> assert_error_message
    end
  end

  defp assert_text_message(%{"message" => %{"text" => message}}) do
    assert message ==
             "Hello!I'm BoB.\nSay 'Hi BoB' or select in the menu if you want to search.\n"
  end

  defp assert_selection_message([%{"message" => %{"text" => greeting}} | _] = messages) do
    assert length(messages) == 2
    assert greeting == "Hello Joe!"
  end

  defp assert_quick_reply_message(%{"message" => %{"quick_replies" => replies}}) do
    assert length(replies) == 2

    assert List.first(replies) == %{
             "content_type" => "text",
             "payload" => "bitcoin",
             "title" => "bitcoin"
           }
  end

  defp assert_pirce_list_message(messages) do
    %{"message" => %{"text" => instruction}} = List.last(messages)

    assert length(messages) == 3

    assert instruction ==
             "That's all. If you want to search the other coin, feels free to say 'Hi BoB' or you can select in the menu.\n"
  end

  defp assert_error_message(%{"message" => %{"text" => message}}) do
    assert message ==
             "Something went wrong. Our Engineers are working on it."
  end
end
