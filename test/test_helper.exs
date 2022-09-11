Mox.defmock(AgentBob.BotMock, for: AgentBob.Bot.Behavior)
Application.put_env(:agent_bob, :bot, AgentBob.BotMock)

Mox.defmock(AgentBob.CoingeckoMock, for: AgentBob.Coingecko.Behavior)
Application.put_env(:agent_bob, :coingecko, AgentBob.CoingeckoMock)

ExUnit.start()
