defmodule FoodieFriends.Repo.Migrations.CustomizePosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :published_on, :utc_datetime
      add :visible, :boolean, default: true

      remove :subtitle
    end
    create unique_index(:posts, :title)
  end
end
