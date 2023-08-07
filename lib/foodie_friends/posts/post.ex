defmodule FoodieFriends.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string
    field :visible, :boolean, default: true
    field :published_on, :utc_datetime

    belongs_to :user, FoodieFriends.Accounts.User
    has_one :cover_image, FoodieFriends.Posts.CoverImage, on_replace: :update
    has_many :comments, FoodieFriends.Comments.Comment
    many_to_many :tags, FoodieFriends.Tags.Tag, join_through: "posts_tags", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(post, attrs, tags \\ []) do
    post
    |> cast(attrs, [:title, :content, :visible, :published_on, :user_id])
    |> cast_assoc(:cover_image)
    |> validate_required([:title, :content, :visible, :user_id])
    |> unique_constraint(:title)
    |> foreign_key_constraint(:user_id)
    |> put_assoc(:tags, tags)
  end
end
