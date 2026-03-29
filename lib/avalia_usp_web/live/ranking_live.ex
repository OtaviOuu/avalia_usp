defmodule AvaliaUspWeb.RankingLive do
  use AvaliaUspWeb, :live_view

  def mount(_params, _session, socket) do
    professores = AvaliaUsp.Professores.list_professores!(query: [limit: 10])

    socket
    |> assign(:professores, professores)
    |> ok
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Ranking
      </.header>

      <ul class="list bg-base-100 rounded-box shadow-md">
        <li class="p-4 pb-2 text-xs opacity-60 tracking-wide">Most played songs this week</li>

        <li :for={professor <- @professores} class="list-row">
          <div class="text-4xl font-thin opacity-30 tabular-nums">01</div>
          <div>
            <img
              class="size-10 rounded-box"
              src={professor.profile_picture_url}
            />
          </div>
          <div class="list-col-grow">
            <div>{professor.nome_completo}</div>
            <div class="text-xs uppercase font-semibold opacity-60">Remaining Reason</div>
          </div>
          <button class="btn btn-square btn-ghost">
            10
          </button>
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
