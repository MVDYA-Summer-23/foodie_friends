defmodule FoodieFriends.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodieFriends.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    tags = attrs[:tags] || []

    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "some post title",
        content: "some post content",
        visible: true,
        published_on: DateTime.utc_now()
      })
      |> FoodieFriends.Posts.create_post(tags)

    post
  end
end
