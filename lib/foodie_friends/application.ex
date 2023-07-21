defmodule FoodieFriends.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FoodieFriendsWeb.Telemetry,
      # Start the Ecto repository
      FoodieFriends.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FoodieFriends.PubSub},
      # Start Finch
      {Finch, name: FoodieFriends.Finch},
      # Start the Endpoint (http/https)
      FoodieFriendsWeb.Endpoint
      # Start a worker by calling: FoodieFriends.Worker.start_link(arg)
      # {FoodieFriends.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodieFriends.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodieFriendsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
