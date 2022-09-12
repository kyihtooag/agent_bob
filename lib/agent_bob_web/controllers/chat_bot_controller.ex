defmodule AgentBobWeb.ChatBotController do
  use AgentBobWeb, :controller

  alias AgentBob.Bot
  alias AgentBob.Handler

  @spec verify_webhook_token(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def verify_webhook_token(conn, params) do
    with true <- Bot.verify_webhook(params),
         :ok <- Bot.setup_bot() do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, params["hub.challenge"])
      |> send_resp()
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(403, Jason.encode!(%{status: "error", message: "unauthorized"}))
    end
  end

  def handle_events(conn, event_data) do
    event_data
    |> Handler.handle_events()
    |> Bot.send_message()

    conn
    |> put_resp_content_type("application/json")
    |> resp(200, Jason.encode!(%{status: "ok"}))
  end
end
