defmodule PucksWeb.ErrorView do
  use PucksWeb, :view
  use JaSerializer.PhoenixView

  def render("400.json-api", %{data: changeset}) do
    JaSerializer.EctoErrorSerializer.format(changeset)
  end

  def render("401.json-api", %{detail: detail}) do
    
    %{status: 401, title: "Unauthorized", detail: detail}
    |>JaSerializer.ErrorSerializer.format()    
  
  end


  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end


end
