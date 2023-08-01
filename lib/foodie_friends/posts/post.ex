defmodule FoodieFriends.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string
    field :visible, :boolean, default: true
    field :published_on, :utc_datetime

    belongs_to :user, FoodieFriends.Accounts.User
    has_many :comments, FoodieFriends.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :visible, :published_on, :user_id])
    |> validate_required([:title, :content, :visible, :published_on, :user_id])
    |> unique_constraint(:title)
    |> foreign_key_constraint(:user_id)
  end
end
