defmodule Spamzapper.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:phpbb3_users, primary_key: false) do
      add :user_id, :bigserial, primary_key: true
      add :user_type, :integer
      add :group_id, :integer
      add :user_ip, :string
      add :username, :string
      add :user_email, :string
      add :user_warnings, :integer
      add :user_login_attempts, :integer
      add :user_inactive_time, :integer
      add :user_posts, :integer
      add :user_lang, :string
      add :user_rank, :integer
      add :user_allow_pm, :boolean, default: true, null: false
      add :user_sig, :text
      add :user_website, :string
    end

  end
end
