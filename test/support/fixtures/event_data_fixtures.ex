defmodule AgentBob.EventDataFixtures do
  # It will be replace with Mock tests
  def event_data() do
    %{
      "entry" => [
        %{
          "id" => "105039412352938",
          "messaging" => [
            %{
              "message" => %{
                "text" => "hi"
              },
              "recipient" => %{"id" => "105039412352938"},
              "sender" => %{"id" => "5341236229326509"},
              "timestamp" => 1_662_828_989_241
            }
          ],
          "time" => 1_662_828_989_604
        }
      ],
      "object" => "page"
    }
  end
end
