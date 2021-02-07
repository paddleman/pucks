defmodule PucksWeb.SessionController do
  use PucksWeb, :controller

  alias Pucks.People
  alias Pucks.People.User


  def create(conn, %{"email" => email, "password" => password}) do
    try do
      user = People.get_user_by_email!(email)

      if Bcrypt.verify_pass(password, user.password_hash) do
        conn
        |> render("token.json", %{user: user})

      else
        conn
        |>put_status(:unauthorized)
        |> put_view(Pucks.ErrorView)
        |> render("401.json-api", %{detail: "Error loggin in with email and password"})
      end

    rescue
      _err ->
        Bcrypt.no_user_verify()
        conn
        |>put_status(:unauthorized)
        |>put_view(PucksWeb.ErrorView)
        |>render("401.json-api", %{detail: "Error loggin in with email and password"})
    end
  end

end
