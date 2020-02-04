defmodule Spamzapper.Forum.Member do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:user_id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :user_id}

  schema "phpbb3_users" do
    field :group_id, :integer
    field :user_allow_pm, :boolean, default: false
    field :user_email, :string
    field :user_inactive_time, :integer
    field :user_ip, :string
    field :user_lang, :string
    field :user_login_attempts, :integer
    field :user_posts, :integer
    field :user_rank, :integer
    field :user_sig, :string
    field :user_type, :integer
    field :user_warnings, :integer
    field :user_website, :string
    field :username, :string
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_type, :group_id, :user_ip, :username, :user_email, :user_warnings, :user_login_attempts, :user_inactive_time, :user_posts, :user_lang, :user_rank, :user_allow_pm, :user_sig, :user_website])
    |> validate_required([:user_type, :group_id, :user_ip, :username, :user_email, :user_warnings, :user_login_attempts, :user_inactive_time, :user_posts, :user_lang, :user_rank, :user_allow_pm, :user_sig, :user_website])
  end
end
