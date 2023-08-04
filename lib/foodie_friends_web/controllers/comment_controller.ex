defmodule FoodieFriendsWeb.CommentController do
  use FoodieFriendsWeb, :controller

  alias FoodieFriends.Comments
  alias FoodieFriends.Comments.Comment
  alias FoodieFriends.Posts

  # TODO: Check if this action is even necessary given that posts should include comment changesets for comment forms
  # def new(conn, _params) do
  #   changeset = Comments.change_comment(%Comment{})
  #   render(conn, :new, changeset: changeset)
  # end

  def create(conn, %{"comment" => comment_params}) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/posts/#{comment.post_id}")

      {:error, %Ecto.Changeset{} = _comment_changeset} ->
        post = Posts.get_post!(comment_params["post_id"])
        conn
        |> put_flash(:error, "Comment not created. Is your comment blank?")
        |> redirect(to: ~p"/posts/#{post.id}")
    end
  end

  # def edit(conn, %{"id" => id}) do
  #   comment = Comments.get_comment!(id)
  #   changeset = Comments.change_comment(comment)
  #   render(conn, :edit, comment: comment, changeset: changeset)
  # end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: ~p"/posts/#{comment.post_id}")

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:info, "Something went wrong, comment could not be created.")
        |> redirect(to: ~p"/posts/#{comment.post_id}")
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/posts/#{comment.post_id}")
  end
end
