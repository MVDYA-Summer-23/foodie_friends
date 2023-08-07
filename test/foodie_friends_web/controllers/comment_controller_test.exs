defmodule FoodieFriendsWeb.CommentControllerTest do
  use FoodieFriendsWeb.ConnCase

  import FoodieFriends.CommentsFixtures
  import FoodieFriends.PostsFixtures
  import FoodieFriends.AccountsFixtures


  describe "create comment" do
    test "redirects to associated post page when data is valid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      create_attrs = %{content: "some created comment content", post_id: post.id, user_id: user.id}

      conn = log_in_user(conn, user)
      conn = post(conn, ~p"/comments", comment: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "some created comment content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      invalid_attrs = %{content: nil, post_id: post.id, user_id: user.id}
      conn = log_in_user(conn, user)
      conn = post(conn, ~p"/comments", comment: invalid_attrs)
      assert redirected_to(conn) == ~p"/posts/#{post.id}"
    end
  end

  # BONUS: Maybe we can just drop this one
  # describe "edit comment" do
  #   test "renders form for editing chosen comment", %{conn: conn, comment: comment} do
  #     user = user_fixture()
  #     post = post_fixture(user_id: user.id)
  #     comment = comment_fixture(post_id: post.id, user_id: user.id)
  #     conn = log_in_user(conn, user)
  #     conn = get(conn, ~p"/posts/#{post.id}/edit")
  #     assert html_response(conn, 200) =~ "Edit Comment"
  #   end
  # end

  describe "update comment" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      update_attrs = %{content: "some updated comment content", post_id: post.id, user_id: user.id}
      comment = comment_fixture(post_id: post.id, user_id: user.id)

      conn = log_in_user(conn, user)
      conn = put(conn, ~p"/comments/#{comment}", comment: update_attrs)

      assert redirected_to(conn) == ~p"/posts/#{post.id}"

      conn = get(conn, ~p"/posts/#{post.id}")
      assert html_response(conn, 200)
    end

    test "a user cannot update another user's comment", %{conn: conn} do
      post_user = user_fixture()
      other_user = user_fixture()
      post = post_fixture(user_id: post_user.id)
      comment = comment_fixture(post_id: post.id, user_id: post_user.id)
      update_attrs = %{content: "some updated content", post_id: post.id}

      conn = log_in_user(conn, other_user)

      conn = put(conn, ~p"/comments/#{comment}", comment: update_attrs)

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "You can only edit or delete your own comments"

      assert redirected_to(conn) == ~p"/posts/#{post.id}"
    end

    # BONUS check if put_flash contains errors
    # TODO: is it possible to also check that errors were rendered?
    test "redirects to post when new comment is invalid", %{conn: conn} do
      # test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      comment = comment_fixture(post_id: post.id, user_id: user.id)
      invalid_attrs = %{content: nil, post_id: post.id, user_id: user.id}
      conn = log_in_user(conn, user)
      conn = put(conn, ~p"/comments/#{comment}", comment: invalid_attrs)
      # Added assert redirection to comply with expected behavior
      assert redirected_to(conn) == ~p"/posts/#{comment.post_id}"
    end
  end

  describe "delete comment" do
    test "deletes chosen comment", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      comment = comment_fixture(post_id: post.id, user_id: user.id)
      conn = log_in_user(conn, user)
      conn = delete(conn, ~p"/comments/#{comment}")
      assert redirected_to(conn) == ~p"/posts/#{post.id}"
    end

    test "a user cannot delete another user's comment", %{conn: conn} do
      comment_user = user_fixture()
      other_user = user_fixture()
      post = post_fixture(user_id: comment_user.id)

      comment =
        comment_fixture(
          content: "some comment content",
          post_id: post.id,
          user_id: comment_user.id
        )

      conn = log_in_user(conn, other_user)
      conn = delete(conn, ~p"/comments/#{comment}")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "You can only edit or delete your own comments"

      assert redirected_to(conn) == ~p"/posts/#{post.id}"
    end
  end
end
