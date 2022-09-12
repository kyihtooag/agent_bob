defmodule AgentBobWeb.ChatBotControllerTest do
  use AgentBobWeb.ConnCase

  import AgentBob.EventDataFixtures
  import Mox

  setup :verify_on_exit!

  @webhook_api "/api/fb_webhook"

  describe "verify_webhook/1" do
    test "returns challenge int to facebook if both webhook mode and token are matched ", %{
      conn: conn
    } do
      challenge_int = 1_630_316_461

      params = %{
        "hub.challenge" => challenge_int,
        "hub.mode" => "subscribe",
        "hub.verify_token" => "agent_bob"
      }

      AgentBob.BotMock
      |> expect(:verify_webhook, fn _ -> true end)
      |> expect(:setup_bot, fn -> :ok end)

      response =
        conn
        |> get(@webhook_api, params)
        |> json_response(200)

      assert response == challenge_int
    end

    test "returns 403 error if either webhook mode or token are not matched", %{conn: conn} do
      params = %{
        "hub.challenge" => 0,
        "hub.mode" => "invalid",
        "hub.verify_token" => "invalid"
      }

      AgentBob.BotMock
      |> expect(:verify_webhook, fn _ -> false end)

      response =
        conn
        |> get(@webhook_api, params)
        |> json_response(403)

      assert response == %{"message" => "unauthorized", "status" => "error"}
    end
  end

  describe "handle_events" do
    test "handle chat bot events and returns 200", %{conn: conn} do
      AgentBob.BotMock
      |> expect(:send_message, fn _ -> :ok end)

      response =
        conn
        |> post(@webhook_api, build_text_message("Hi"))
        |> json_response(200)

      assert response == %{"status" => "ok"}
    end
  end
end
