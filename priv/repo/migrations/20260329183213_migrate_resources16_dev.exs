defmodule AvaliaUsp.Repo.Migrations.MigrateResources16 do
  use Ecto.Migration

  def up do
    alter table(:avaliacaos) do
      add :encrypted_comentario, :binary
    end
  end

  def down do
    alter table(:avaliacaos) do
      remove :encrypted_comentario
    end
  end
end
