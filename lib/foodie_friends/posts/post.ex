defmodule FoodieFriends.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :published_on, :utc_datetime
    field :title, :string
    field :visible, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :visible, :published_on, :content])
    |> validate_required([:title, :visible, :published_on, :content])
    |> unique_constraint(:title)
  end
end
