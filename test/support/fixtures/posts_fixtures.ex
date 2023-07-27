defmodule FoodieFriends.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodieFriends.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title",
        published_on: DateTime.utc_now(),
        visible: true
      })
      |> FoodieFriends.Posts.create_post()

    post
  end
end
