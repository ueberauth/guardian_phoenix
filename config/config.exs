use Mix.Config

config :phoenix, :json_library, Jason
config :guardian, Guardian.Phoenix.ControllerTest.Endpoint, secret_key_base: "lksdjfl"
config :guardian, Guardian.Phoenix.TestSupport.Impl, []
