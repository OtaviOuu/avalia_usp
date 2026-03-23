defmodule AvaliaUspWeb.DisciiplinasLive.Show do
  use AvaliaUspWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Detalhes da Disciplina
        <:subtitle>sla</:subtitle>
      </.header>
      <p>Em construção...</p>
    </Layouts.app>
    """
  end
end
