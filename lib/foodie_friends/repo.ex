defmodule FoodieFriends.Repo do
  use Ecto.Repo,
    otp_app: :foodie_friends,
    adapter: Ecto.Adapters.Postgres
end
