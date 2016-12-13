defmodule Volt.SessionController do
  use Volt.Web, :controller
  import Logger

  alias Volt.User
  alias Volt.Plugs.Auth

  plug Volt.Plugs.RequireAuth when action in [:changepwd_show, :changepwd_update]


  def new(conn, _params) do
    changeset = User.login_changeset(%User{})
    render conn, "login.html", changeset: changeset
  end

  def create(conn, %{"user" => %{"email" => email, "password" => pass}}) do

    case Auth.validate_password(conn, email, pass) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back #{email}")
        |> redirect(to: page_path(conn, :index))
      _ ->
        changeset = User.login_changeset(%User{}, %{"email" => email, "password" => pass})
        render conn, "login.html", changeset: %{changeset | action: :insert}
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout
    |> redirect(to: page_path(conn, :index))
  end

  #--------- Change Password functionality -----

  @doc """
    renders the change password page
  """
  def changepwd_show(conn, params) do
    Logger.info "Params: #{inspect(params)}"
    changeset =
      changepwd_changeset(%User{}, params)
    render conn, "changepwd.html", changeset: changeset
  end

  @doc """
    POST method which takes in the given params, validates and changes the current_user password
  """
  def changepwd_update(conn, %{"changepwd" => params}) do
    Logger.info "changepwd_update: Params: #{inspect(params)}"
    user = Repo.get(User, get_session(conn, :user_id))
    changeset = changepwd_changeset(%{}, params, user)

    if changeset.valid? do
      Logger.info "changeset #{inspect(changeset)}"
      Repo.update_all(User, set: [password: changeset.changes.password])
      conn
      |> put_flash(:info, "Change password is successful #{user.email}")
      |> redirect(to: page_path(conn, :index))
    else
      Logger.info "changeset: #{inspect(changeset)}"
      render conn, "changepwd.html", changeset: %{changeset | action: :update}
    end
  end

  defp changepwd_changeset(struct, params \\ %{}, user \\ %User{}) do
    types = %{old_password: :string, password: :string, password_confirmation: :string}
    {struct, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(Map.keys(types))
    |> User.confirm_password
    |> User.put_password_hash
    |> User.validate_user_password(user)
  end

end
