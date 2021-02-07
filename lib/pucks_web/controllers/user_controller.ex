defmodule PucksWeb.UserController do
  use PucksWeb, :controller

  alias Pucks.People
  alias Pucks.People.User

  action_fallback PucksWeb.FallbackController

  plug :authenticate_user when action in [:show_current]

  def show_current(conn, %{current_user: user}) do

    conn
    |> render("show.json-api", data: user)

  end

  def index(conn, _params) do
    users = People.list_users()
    render(conn, "index.json-api", data: users)
  end


  def create(conn, %{"data" => data = %{"type" => "users", "attributes" => user_params}}) do
    attrs = JaSerializer.Params.to_attributes(data)

    case People.create_user(attrs) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> render("show.json-api", data: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(PucksWeb.ErrorView)
        |> render("400.json-api", data: changeset)

    end
  end


  def show(conn, %{"id" => id}) do
    user = People.get_user!(id)
    render(conn, "show.json-api", data: user)
  end


  def delete(conn, %{"id" => id}) do
    user = People.get_user!(id)

    with {:ok, %User{}} <- People.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

end
