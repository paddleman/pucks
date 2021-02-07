defmodule Pucks.People.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string 
    
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation])
    |> validate_required([:username, :email, :password, :password_confirmation])
    |> unsafe_validate_unique([:username], Pucks.Repo)
    |> unsafe_validate_unique([:email], Pucks.Repo)
    |> validate_confirmation(:password)    
    |> hash_the_password()

  end

  defp hash_the_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        hash = Bcrypt.add_hash(password)
  
        put_change(changeset, :password_hash, hash.password_hash)
      _ ->
          changeset       
    end
  
  end
          
end
