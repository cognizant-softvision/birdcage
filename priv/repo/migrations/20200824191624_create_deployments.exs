defmodule Birdcage.Repo.Migrations.CreateDeployments do
  use Ecto.Migration

  def change do
    create table(:deployments, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:namespace, :string, null: false)
      add(:phase, :string, null: false)
      add(:allow_rollout, :boolean, default: false, null: false)
      add(:allow_promotion, :boolean, default: false, null: false)
      add(:confirm_rollout_at, :utc_datetime)
      add(:confirm_promotion_at, :utc_datetime)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:deployments, [:name, :namespace]))
  end
end
