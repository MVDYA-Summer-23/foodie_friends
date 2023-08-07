defmodule FoodieFriendsWeb.FoodieFriendsComponents do
  use Phoenix.Component

  # alias Phoenix.LiveView.JS
  # import FoodieFriendsWeb.Gettext


  def page_header(assigns) do
    ~H"""
    <header class="flex justify-center items-center w-full h-[150px] bg-gray-300">
      <h1 class="text-3xl">Foodie Friends</h1>
    </header>
    """
  end
end
