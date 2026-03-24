defmodule AvaliaUspWeb.AvaliarLive do
  use AvaliaUspWeb, :live_view

  on_mount {AvaliaUspWeb.LiveUserAuth, :live_user_required}

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Avaliar Professor
      </.header>
    </Layouts.app>
    """
  end
end
