defmodule AgentBob.BotTest do
  use ExUnit.Case, async: true

  alias AgentBob.Bot

  describe "verify_webhook/1" do
    test "returns true if both webhook mode and token are matched" do
      params = %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => "agent_bob"
      }

      assert Bot.verify_webhook(params)
    end

    test "returns false if either webhook mode or token are not match" do
      params = %{
        "hub.mode" => "invalid",
        "hub.verify_token" => "invalid"
      }

      refute Bot.verify_webhook(params)
    end
  end
end
