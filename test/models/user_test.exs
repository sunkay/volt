defmodule Volt.UserTest do
  use Volt.ModelCase

  alias Volt.User

  @valid_attrs %{email: "some@content", password: "some content", password_confirmation: "some content"}
  @invalid_password %{email: "some@content", password: "some content", password_confirmation: "wrong"}
  @no_confirm_attr %{email: "some@content", password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset checks unique_constraint voilation" do
    _ = insert_user(@valid_attrs)
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset confirm_password returns error hen it does not match" do
    changeset = User.registration_changeset(%User{}, @invalid_password)
    refute changeset.valid?
  end

  test "changeset confirm_password returns error when it does NOT have a confirm_password field present" do
    changeset = User.registration_changeset(%User{}, @no_confirm_attr)
    refute changeset.valid?
  end

end
