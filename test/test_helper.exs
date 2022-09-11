Mox.defmock(AgentBob.BotMock, for: AgentBob.Bot.Behavior)
Application.put_env(:agent_bob, :bot, AgentBob.BotMock)

ExUnit.start()
