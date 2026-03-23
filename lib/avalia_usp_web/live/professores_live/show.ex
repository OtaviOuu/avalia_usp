defmodule AvaliaUspWeb.ProfessoresLive.Show do
  use AvaliaUspWeb, :live_view

  def mount(%{"professor_nome" => professor_nome}, _session, socket) do
    socket
    |> assign_professor_details(professor_nome)
    |> ok()
  end

  def assign_professor_details(socket, professor_nome) do
    socket
    |> assign_async(:professor, fn ->
      {:ok,
       %{
         professor:
           AvaliaUsp.Professores.get_professor_by_nome_completo!(professor_nome,
             load: [:disciplinas, :avaliacoes]
           )
       }}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Detalhes do Professor
        <:subtitle>sla</:subtitle>
      </.header>
      <.async_result :let={professor} assign={@professor}>
        <:loading><.loading_spinner /></:loading>
        <:failed :let={_failure}>erro ao buscar profesosre</:failed>

        <.professor_details professor={professor} />
        <.search_form professor={professor} />

        <.avaliacoes_list avaliacoes={professor.avaliacoes} />
      </.async_result>
    </Layouts.app>
    """
  end

  defp search_form(assigns) do
    ~H"""
    <form class="flex items-center justify-center gap-4" phx-change="search" phx-debounce="500">
      <label class="input">
        <.icon name="hero-magnifying-glass" class="size-5 opacity-60" />
        <input type="search" name="q" placeholder="Search" />
      </label>
      <select class="select" name="disciplina">
        <option disabled selected>Disciplina</option>
        <option :for={disciplina <- @professor.disciplinas}>{disciplina.nome}</option>
      </select>
    </form>
    """
  end

  def handle_event("search", %{"q" => query, "disciplina" => disciplina}, socket) do
    dbg({query, disciplina})

    socket
    |> noreply
  end

  attr :professor, :map, doc: "O professor a ser exibido"

  defp professor_details(assigns) do
    ~H"""
    <div class="card bg-base-100 border border-base-300 shadow-sm">
      <div class="card-body gap-4">
        <div class="flex items-center gap-4">
          <div class="avatar">
            <div class="w-16 rounded-full">
              <img src="https://img.daisyui.com/images/profile/demo/2@94.webp" />
            </div>
          </div>

          <div class="flex-1">
            <h2 class="card-title text-lg">
              {@professor.nome_completo}
            </h2>

            <p class="text-sm opacity-60">
              {@professor.email}
            </p>
          </div>

          <div class="badge badge-ghost text-base font-medium">
            ★ {Float.round(@professor.media_avaliacoes || 0, 1)}
          </div>
        </div>

        <div class="flex flex-wrap gap-2">
          <span
            :for={disciplina <- @professor.disciplinas}
            class="badge badge-outline text-xs"
          >
            {disciplina.nome}
          </span>
        </div>

        <div class="flex items-center gap-2 text-xs">
          <span class="badge badge-success badge-outline">
            {@professor.quantidade_avaliacoes_positivas}
          </span>

          <span class="badge badge-error badge-outline">
            {@professor.quantidade_avaliacoes_negativas}
          </span>

          <span class="badge badge-ghost">
            {@professor.quantidade_avaliacoes} total
          </span>
        </div>
      </div>
    </div>
    """
  end

  attr :avaliacoes, :list, doc: "Lista de avaliações do professor"

  defp avaliacoes_list(assigns) do
    ~H"""
    <ul class="list rounded-box shadow-md bg-base-100 border border-base-300">
      <.avaliacao_row :for={avaliacao <- @avaliacoes} avaliacao={avaliacao} />
    </ul>
    """
  end

  defp avaliacao_row(assigns) do
    ~H"""
    <li class="list-row  hover:border-primary transition cursor-pointer">
      <div>
        <img
          class="size-10 rounded-box"
          src="https://img.daisyui.com/images/profile/demo/1@94.webp"
        />
      </div>
      <div>
        <div>Dio Lupa</div>
        <div class="text-xs uppercase font-semibold opacity-60">Remaining Reason</div>
      </div>
      <p class="list-col-wrap text-xs">
        {@avaliacao.comentario}
      </p>
      <.button class="btn btn-square btn-ghost">
        <.icon name="hero-chevron-up" />
      </.button>
      <.button class="btn btn-square btn-ghost">
        <.icon name="hero-chevron-down" />
      </.button>
    </li>
    """
  end
end
