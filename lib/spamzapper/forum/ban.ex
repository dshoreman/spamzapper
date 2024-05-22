defmodule Spamzapper.Forum.Ban do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:ban_id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :ban_id}

  schema "phpbb3_banlist" do
    field :ban_userid, :integer
    field :ban_ip, :string
    field :ban_email, :string
    field :ban_start, :integer
    field :ban_end, :integer
    field :ban_exclude, :boolean, default: false
    field :ban_reason, :string
    field :ban_give_reason, :string
  end

  @doc false
  def changeset(ban, attrs) do
    ban
    |> cast(attrs, [:ban_userid, :ban_ip, :ban_email, :ban_start, :ban_end, :ban_exclude, :ban_reason, :ban_give_reason])
    |> validate_required([:ban_userid, :ban_ip, :ban_email, :ban_start, :ban_end, :ban_exclude, :ban_reason, :ban_give_reason])
  end

  @doc false
  def email_changeset(ban, attrs) do
    ban
    |> cast(attrs, [:ban_email, :ban_start, :ban_end, :ban_reason, :ban_give_reason])
    |> validate_required([:ban_email, :ban_start, :ban_end, :ban_reason, :ban_give_reason])
  end
end
