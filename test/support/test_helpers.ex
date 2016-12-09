defmodule Volt.TestHelpers do
  alias Volt.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      email: "Some@User.com",
      password: "supersecret",
      password_confirmation: "supersecret"
      }, attrs)

      %Volt.User{}
      |> Volt.User.registration_changeset(changes)
      |> Repo.insert!()
  end
end
