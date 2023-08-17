defmodule FoodieFriendsWeb.FoodieFriendsComponents do
  # TODO: Rename module please
  use Phoenix.Component

  # alias Phoenix.LiveView.JS
  # import FoodieFriendsWeb.Gettext

  def page_header(assigns) do
    ~H"""
    <header class="flex justify-center items-center w-full h-[250px] bg-gray-300">
      <div class="bg-center bg-[0_-22rem] bg-no-repeat h-full w-full bg-[url('https://images.unsplash.com/photo-1551529834-525807d6b4f3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1131&q=80')]">
        <h1 class="font-brand text-white text-7xl text-center mt-6 drop-shadow-2xl" style="text-shadow: 5px 5px 4px rgba(0, 0, 0, 0.5); text-shadow: 5px -5px 4px rgba(0, 0, 0, 0.8); text-shadow: -5px -5px 4px rgba(0, 0, 0, 0.5); text-shadow: -5px 5px 4px rgba(0, 0, 0, 0.5)">Foodie Friends</h1>
      </div>
    </header>
    """
  end
end
