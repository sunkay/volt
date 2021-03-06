defmodule Volt.UserControllerTest do
  use Volt.ConnCase

  alias Volt.User
  @valid_attrs %{email: "x@y.com", password: "some content", password_confirmation: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} = config do
    if config[:logged_out] do
      :ok
    else
      user = insert_user(email: "x@y.com")
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    end
  end

  @tag :logged_out
  test "redirect happens when there is no user session",
      %{conn: conn} do

    Enum.each([
      get(conn, user_path(conn, :index)),
      get(conn, user_path(conn, :show, "123")),
      get(conn, user_path(conn, :edit, "123")),
      put(conn, user_path(conn, :update, "123", %{})),
      delete(conn, user_path(conn, :show, "123"))
      ], fn conn ->
        assert redirected_to(conn) == page_path(conn, :index)
        assert conn.halted
    end)
  end

  test "lists all entries on index is redirected", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  @tag :logged_out
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == session_path(conn, :new)
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end
end
