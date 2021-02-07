defmodule PucksWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use PucksWeb, :controller
      use PucksWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: PucksWeb

      import Plug.Conn
      import PucksWeb.Gettext
      alias PucksWeb.Router.Helpers, as: Routes

      alias Pucks.People

      def authenticate_user(conn, _params) do
        try do
          ["Bearer " <> token] = get_req_header(conn, "authorization")

          signer = Joken.Signer.create("HS512", (Application.get_env(:pucks, :jwt_secret)))
          claims = Token.verify_and_validate!(token, signer)

          %{"sub" => user_id} = claims

          user = People.get_user!(user_id)

          params = Map.get(conn, :params) #assigning the :params from the connection to local map variable
          |>Map.put(:current_user, user)  #adding a :current_user key to the map, and assigning its value to the user that was returned from the token

          conn
          |> Map.put(:params, params)   #assigning the :params map to the altered params map

        rescue
          _err ->
            conn
            |> put_status(:unauthorized)
            |> put_view(PucksWeb.ErrorView)
            |> render("401.json-api", %{detail: "User must be logged in to view this resource"})
            |> halt
        end
      end


    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/pucks_web/templates",
        namespace: PucksWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import PucksWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import PucksWeb.ErrorHelpers
      import PucksWeb.Gettext
      alias PucksWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
