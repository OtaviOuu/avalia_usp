defmodule AvaliaUspWeb.HomeLive do
  use AvaliaUspWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> assign(:page_title, "Professores")
    |> assign_stats()
    |> ok()
  end

  def assign_stats(socket) do
    socket
    |> assign_async(:stats, fn ->
      {:ok, %{stats: AvaliaUsp.Analytics.get_geral_aggregates!()}}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Buscar Professores
        <:actions>
          <.button class="btn btn-secundary" phx-click={JS.navigate(~p"/disciplinas")}>
            Disciplinas
          </.button>
        </:actions>
      </.header>

      <.stats_banner :if={@stats.ok?} stats={@stats} />

      <Cinder.collection
        resource={AvaliaUsp.Professores.Professor}
        theme={AvaliaUspWeb.Themes.CinderTheme}
        layout={:grid}
        grid_columns={2}
        page_size={[default: 10, options: [10, 25, 50, 100]]}
      >
        <:col :let={professor} field="nome_completo" search></:col>
        <:col :let={professor} field="quantidade_avaliacoes" sort></:col>

        <:item :let={professor}>
          <.professor_card professor={professor} />
        </:item>
      </Cinder.collection>
    </Layouts.app>
    """
  end

  attr :professor, AvaliaUsp.Professores.Professor, required: true

  defp professor_card(assigns) do
    ~H"""
    <div
      phx-click={JS.navigate(~p"/professores/#{@professor.nome_completo}")}
      id={"professor-card-#{@professor.id}"}
      class="card h-full w-full bg-base-100 border border-base-300 hover:border-primary transition cursor-pointer"
    >
      <div class="card-body gap-2 p-4 sm:p-6 flex flex-col justify-between">
        <div class="flex flex-col gap-2">
          <div class="flex items-start justify-between gap-2">
            <h2 class="card-title text-sm leading-snug line-clamp-2">
              {@professor.nome_completo}
            </h2>
            <div
              :if={@professor.quantidade_avaliacoes != 0}
              class="badge badge-ghost badge-sm shrink-0"
            >
              {@professor.media_avaliacoes}
            </div>
          </div>
          <p class="text-xs sm:text-sm opacity-60 truncate">
            {@professor.email}
          </p>
        </div>
        <div class="flex flex-wrap items-center gap-1.5 sm:gap-2 mt-1 sm:mt-2">
          <span class="badge badge-success badge-outline badge-sm sm:badge-md">
            {@professor.quantidade_avaliacoes_positivas}
          </span>
          <span class="badge badge-error badge-outline badge-sm sm:badge-md">
            {@professor.quantidade_avaliacoes_negativas}
          </span>
          <span class="badge badge-ghost badge-sm sm:badge-md">
            {@professor.quantidade_avaliacoes} total
          </span>
        </div>
      </div>
    </div>
    """
  end

  defp stats_banner(assigns) do
    ~H"""
    <div class="card bg-base-100 border border-base-300 w-full">
      <div class="flex divide-x divide-base-300">
        <div class="stat place-items-center flex-1 px-2 py-4">
          <div class="stat-title text-xs sm:text-sm whitespace-nowrap">Avaliações</div>
          <div class="stat-value text-xl sm:text-3xl">{assigns.stats.result.avaliacoes}</div>
        </div>
        <div class="stat place-items-center flex-1 px-2 py-4">
          <div class="stat-title text-xs sm:text-sm whitespace-nowrap">Professores</div>
          <div class="stat-value text-xl sm:text-3xl">{assigns.stats.result.professores}</div>
        </div>
        <div class="stat place-items-center flex-1 px-2 py-4">
          <div class="stat-title text-xs sm:text-sm whitespace-nowrap">Disciplinas</div>
          <div class="stat-value text-xl sm:text-3xl">{assigns.stats.result.disciplinas}</div>
        </div>
      </div>
    </div>
    """
  end
end
