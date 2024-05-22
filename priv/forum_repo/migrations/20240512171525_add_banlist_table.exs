defmodule Spamzapper.ForumRepo.Migrations.AddBanlistTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:phpbb3_banlist, primary_key: false) do
      add :ban_id, :bigserial, primary_key: true
      add :ban_user_id, :integer
      add :ban_ip, :string
      add :ban_email, :string
      add :ban_start, :integer
      add :ban_end, :integer
      add :ban_exclude, :boolean, default: false, null: false
      add :ban_reason, :string
      add :ban_give_reason, :string
    end
  end
end
