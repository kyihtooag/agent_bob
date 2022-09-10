defmodule AgentBobWeb.ChatBotController do
  use AgentBobWeb, :controller

  alias AgentBob.Bot

  @spec verify_webhook_token(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def verify_webhook_token(conn, params) do
    verified? = Bot.verify_webhook(params)

    if verified? do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, params["hub.challenge"])
      |> send_resp()
    else
      conn
      |> put_resp_content_type("application/json")
      |> resp(403, Jason.encode!(%{status: "error", message: "unauthorized"}))
    end
  end
end
