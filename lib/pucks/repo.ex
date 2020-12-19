defmodule Pucks.Repo do
  use Ecto.Repo,
    otp_app: :pucks,
    adapter: Ecto.Adapters.Postgres
end
