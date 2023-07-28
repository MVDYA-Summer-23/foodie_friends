defmodule FoodieFriends.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodieFriends.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> FoodieFriends.Comments.create_comment()

    comment
  end
end
