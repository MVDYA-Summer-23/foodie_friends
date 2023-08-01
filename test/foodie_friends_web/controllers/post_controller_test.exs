defmodule FoodieFriendsWeb.PostControllerTest do
  use FoodieFriendsWeb.ConnCase

  import FoodieFriends.PostsFixtures
  import FoodieFriends.AccountsFixtures

  @create_attrs %{
    content: "some created content",
    published_on: DateTime.utc_now(),
    title: "some created title"
  }
  @update_attrs %{
    content: "some updated content",
    title: "some updated title"
  }
  @invalid_attrs %{content: nil, published_on: nil, title: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Listing Posts"
    end

    test "lists visible posts only", %{conn: conn} do
      user = user_fixture()
      _post = post_fixture(user_id: user.id)

      {:ok, _invisible_post} =
        %{
          content: "some content",
          title: "invisible",
          published_on: DateTime.utc_now(),
          visible: false,
          user_id: user.id
        }
        |> FoodieFriends.Posts.create_post()

      conn = get(conn, ~p"/posts")
      refute html_response(conn, 200) =~ "invisible"
    end

    test "search for posts - non-matching", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(q: "some post title", user_id: user.id)
      conn = get(conn, ~p"/posts", q: "Non-Matching")
      refute html_response(conn, 200) =~ post.title
    end

    test "search for posts - partial match", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(q: "some post title", user_id: user.id)
      conn = get(conn, ~p"/posts", q: "itl")
      assert html_response(conn, 200) =~ post.title
    end

    test "search for posts - exact match", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(q: "some post title", user_id: user.id)
      conn = get(conn, ~p"/posts", q: "some post title")
      assert html_response(conn, 200) =~ post.title
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/posts/new")
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      created_post = Map.put(@create_attrs, :user_id, user_fixture().id)
      conn = post(conn, ~p"/posts", post: created_post)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "Post #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/posts", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    test "renders form for editing chosen post", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = get(conn, ~p"/posts/#{post}/edit")
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      updated_post = Map.put(@update_attrs, :user_id, user.id)
      conn = put(conn, ~p"/posts/#{post}", post: updated_post)
      assert redirected_to(conn) == ~p"/posts/#{post}"

      conn = get(conn, ~p"/posts/#{post}")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      invalid_post = Map.put(@invalid_attrs, :user_id, user.id)
      conn = put(conn, ~p"/posts/#{post}", post: invalid_post)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    test "deletes chosen post", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = conn |> log_in_user(user) |> delete(~p"/posts/#{post}")
      assert redirected_to(conn) == ~p"/posts"

      assert_error_sent(404, fn ->
        get(conn, ~p"/posts/#{post}")
      end)
    end

    test "a user cannot delete another user's post", %{conn: conn} do
      post_user = user_fixture()
      other_user = user_fixture()
      post = post_fixture(user_id: post_user.id)
      conn = conn |> log_in_user(other_user) |> delete(~p"/posts/#{post}")
      # assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
      #          "You can only edit or delete your own posts."

      # TODO: ASK if unauthorized post deletion requests should redirect to Post index page or to the corresponding Post instead.
      # assert redirected_to(conn) == ~p"/posts/#{post}"
      assert redirected_to(conn) == ~p"/posts"
    end
  end
end
