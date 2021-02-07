defmodule Pucks.PeopleTest do
  use Pucks.DataCase

  alias Pucks.People

  describe "users" do
    alias Pucks.People.User

    @valid_attrs %{email: "some email", password: "some password", password_confirmation: "some password_confirmation", password_hash: "some password_hash", username: "some username"}
    @update_attrs %{email: "some updated email", password: "some updated password", password_confirmation: "some updated password_confirmation", password_hash: "some updated password_hash", username: "some updated username"}
    @invalid_attrs %{email: nil, password: nil, password_confirmation: nil, password_hash: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert People.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert People.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = People.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.password == "some password"
      assert user.password_confirmation == "some password_confirmation"
      assert user.password_hash == "some password_hash"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = People.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.password == "some updated password"
      assert user.password_confirmation == "some updated password_confirmation"
      assert user.password_hash == "some updated password_hash"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_user(user, @invalid_attrs)
      assert user == People.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = People.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> People.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = People.change_user(user)
    end
  end
end
