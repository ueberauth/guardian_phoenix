ExUnit.start()

opts = [strategy: :one_for_one, name: Controller.Supervisor]

children = [
  Guardian.Phoenix.TestSupport.Endpoint,
  {Phoenix.PubSub, name: Guardian.Phoenix.PubSub},
  Guardian.Phoenix.TestSupport.Presence
]

Supervisor.start_link(children, opts)
