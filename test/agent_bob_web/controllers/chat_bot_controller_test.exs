defmodule AgentBobWeb.ChatBotControllerTest do
  use AgentBobWeb.ConnCase

  describe "verify_webhook/1" do
    @webhook_api "/api/fb_webhook"

    test "returns challenge int to facebook if both webhook mode and token are matched ", %{
      conn: conn
    } do
      challenge_int = 1_630_316_461

      params = %{
        "hub.challenge" => challenge_int,
        "hub.mode" => "subscribe",
        "hub.verify_token" => "agent_bob"
      }

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

      response =
        conn
        |> get(@webhook_api, params)
        |> json_response(403)

      assert response == %{"message" => "unauthorized", "status" => "error"}
    end
  end
end
