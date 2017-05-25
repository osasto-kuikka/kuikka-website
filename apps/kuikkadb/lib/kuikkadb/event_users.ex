defmodule KuikkaDB.EventUsers do
  @moduledoc """
  ## Table
  ```
  :event_id, references(:event), null: false
  :user_id, references(:users), null: false
  ```

  ## Index
  ```
  index(:event_users, [:event_id, :user_id], unique: true)
  ```
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "event_users" do
    belongs_to :event, KuikkaDB.EventSchema
    belongs_to :user, KuikkaDB.UserSchema
  end
end
