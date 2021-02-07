defmodule PucksWeb.SessionView do
  use PucksWeb, :view
  #use JaSerializer.PhoenixView


  def render("token.json", %{user: user}) do

    user_info = %{id: user.id, email: user.email, username: user.username}

    jwt = %{data: user_info, sub: user.id}
    signer = Joken.Signer.create("HS512", (Application.get_env(:pucks, :jwt_secret)))
    token = Token.generate_and_sign!(jwt, signer)

    %{token: token}
  end

end

# (Application.get_env(:pucks, :jwt_secret))
