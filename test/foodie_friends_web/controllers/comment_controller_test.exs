defmodule FoodieFriendsWeb.CommentControllerTest do
  use FoodieFriendsWeb.ConnCase

  import FoodieFriends.CommentsFixtures
  import FoodieFriends.PostsFixtures

  @create_attrs %{content: "some created comment content"}
  @update_attrs %{content: "some updated comment content"}
  @invalid_attrs %{}

  describe "create comment" do
    test "redirects to associated post page when data is valid", %{conn: conn} do
      post = post_fixture()
      create_attrs = Map.merge(@create_attrs, %{post_id: post.id})
      conn = post(conn, ~p"/comments", comment: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "some created comment content"
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/comments", comment: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "New Comment"
    # end
  end

  # TODO WHEN USER FUNCTIONALITY IS AVAILABLE: This test is needed when Users can login and edit their posts
  describe "edit comment" do
    # setup [:create_comment]

    # test "renders form for editing chosen comment", %{conn: conn, comment: comment} do
    #   conn = get(conn, ~p"/comments/#{comment}/edit")
    #   assert html_response(conn, 200) =~ "Edit Comment"
    # end
  end

  describe "update comment" do
    test "redirects when data is valid", %{conn: conn} do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id)
      conn = put(conn, ~p"/comments/#{comment}", comment: @update_attrs)

      assert redirected_to(conn) == ~p"/posts/#{post.id}"

      conn = get(conn, ~p"/posts/#{post.id}")
      assert html_response(conn, 200)
    end

    # TODO: is it possible to also check that errors were rendered?
    test "redirects to post when new comment is invalid", %{conn: conn} do
      # test "renders errors when data is invalid", %{conn: conn} do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id)
      conn = put(conn, ~p"/comments/#{comment}", comment: @invalid_attrs)
      # Added assert redirection to comply with expected behavior
      assert redirected_to(conn) == ~p"/posts/#{comment.post_id}"
      # assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "delete comment" do
    test "deletes chosen comment", %{conn: conn} do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id)
      conn = delete(conn, ~p"/comments/#{comment}")
      assert redirected_to(conn) == ~p"/posts/#{comment.post_id}"
    end
  end
end
