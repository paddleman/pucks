defmodule PucksWeb.UserView do
  use PucksWeb, :view
  use JaSerializer.PhoenixView

  location "/users/:id"

  attributes [:username, :email]
  
end
