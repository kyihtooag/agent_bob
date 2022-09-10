import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :agent_bob, AgentBobWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gelmaX8saO1J4HmuhXGfvN/C/7GflLN3q0rPR7NwZyddLNn6izHYe+3blyzKBM6m",
  server: false

# In test we don't send emails.
config :agent_bob, AgentBob.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
