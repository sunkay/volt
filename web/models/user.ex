defmodule Volt.User do
  use Volt.Web, :model
  require Logger
  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/ )
    |> unique_constraint(:email)
    |> confirm_password
    |> put_password_hash
  end

  def login_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end

  defp confirm_password(changeset) do
    Logger.warn "#{inspect(changeset)}"
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password, password_confirmation: confirm}} ->
        if password == confirm do
          changeset
        else
          add_error(changeset, :confirm_password, "password confirmation failed")
        end
      %Ecto.Changeset{valid?: false} ->
          changeset
    end
  end
end
