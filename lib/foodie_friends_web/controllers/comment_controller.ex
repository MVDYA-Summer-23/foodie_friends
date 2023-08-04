defmodule FoodieFriendsWeb.CommentController do
  use FoodieFriendsWeb, :controller

  alias FoodieFriends.Comments
  alias FoodieFriends.Posts

  plug :require_user_owns_comment when action in [:update, :delete]

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

  defp require_user_owns_comment(conn, _) do
    comment = Comments.get_comment!(conn.params["id"])

    if comment.user_id != conn.assigns.current_user.id do
      conn
      |> put_flash(:error, "You can only edit or delete your own comments.")
      |> redirect(to: ~p"/posts/#{comment.post_id}")
      |> halt()
    else
      conn
    end
  end
end
