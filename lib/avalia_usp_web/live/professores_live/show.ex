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
        <.avaliacoes_list avaliacoes={professor.avaliacoes} />
      </.async_result>
    </Layouts.app>
    """
  end

  attr :professor, :map, doc: "O professor a ser exibido"

  defp professor_details(assigns) do
    ~H"""
    {@professor.nome_completo}
    """
  end

  attr :avaliacoes, :list, doc: "Lista de avaliações do professor"

  defp avaliacoes_list(assigns) do
    ~H"""
    <ul class="list bg-base-100 rounded-box shadow-md">
      <li class="p-4 pb-2 text-xs opacity-60 tracking-wide">Most played songs this week</li>

      <li
        :for={avaliacao <- @avaliacoes}
        class="list-row"
      >
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
          {avaliacao.comentario}
        </p>
        <.button class="btn btn-square btn-ghost">
          <.icon name="hero-chevron-up" />
        </.button>
        <.button class="btn btn-square btn-ghost">
          <.icon name="hero-chevron-down" />
        </.button>
      </li>
    </ul>
    """
  end
end
