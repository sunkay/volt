defmodule Volt.UserTest do
  use Volt.ModelCase

  alias Volt.User

  @valid_attrs %{email: "some@content", password: "some content", password_confirmation: "some content"}
  @invalid_password %{email: "some@content", password: "some content", password_confirmation: "wrong"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset checks unique_constraint voilation" do
    _ = insert_user(@valid_attrs)
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset confirm_password returns error hen it does not match" do
    changeset = User.changeset(%User{}, @invalid_password)
    refute changeset.valid?
  end

end
