defmodule Volt.UserTest do
  use Volt.ModelCase

  alias Volt.User

  @valid_attrs %{email: "some@content", password: "some content"}
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
end
