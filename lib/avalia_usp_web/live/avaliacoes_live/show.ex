defmodule AvaliaUspWeb.AvaliacoesLive.Show do
  use AvaliaUspWeb, :live_view

  def mount(
        %{"professor_nome" => professor_nome, "avaliacao_id" => avaliacao_id},
        _session,
        socket
      ) do
    socket
    |> assign(:professor_nome, professor_nome)
    |> assign_avaliacao(avaliacao_id)
    |> ok
  end

  defp assign_avaliacao(socket, avaliacao_id) do
    socket
    |> assign_async(:avaliacao, fn ->
      {:ok,
       %{
         avaliacao:
           AvaliaUsp.Professores.get_avaliacao_by_id!(avaliacao_id,
             load: [:professor, :disciplina]
           )
       }}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <.return_to link={~p"/professores/#{@professor_nome}"} />
        <:actions>
          <.button class="btn btn-secundary">
            <.icon name="hero-hand-thumb-up" />
          </.button>
          <.button class="btn btn-secundary">
            <.icon name="hero-hand-thumb-down" />
          </.button>
        </:actions>
      </.header>
      <.async_result :let={avaliacao} assign={@avaliacao}>
        <:loading><.loading_spinner /></:loading>
        <:failed :let={_failure}>erro ao buscar avaliação</:failed>
        <.professor_details professor={avaliacao.professor} />
        <.disciplina_details_card avaliacao={avaliacao} />
        <.avaliacao_details_card avaliacao={avaliacao} />
      </.async_result>
    </Layouts.app>
    """
  end

  defp disciplina_details_card(assigns) do
    ~H"""
    <div class="card bg-base-100 border border-base-300 shadow-sm">
      <div class="card-body px-6 py-4">
        <div class="flex items-center gap-4">
          <div class="flex flex-col gap-0.5 min-w-0">
            <span class="text-sm text-base-content/60 truncate leading-tight">
              {@avaliacao.disciplina.nome}
            </span>
          </div>

          <div class="ml-auto shrink-0">
            <span class="badge badge-ghost font-mono text-xs">
              {@avaliacao.disciplina.codigo}
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :avaliacao, :map, required: true

  defp avaliacao_details_card(assigns) do
    ~H"""
    <div class="card bg-base-100 border border-base-300 shadow-sm">
      <div class="card-body gap-4 flex items-center">
        {@avaliacao.comentario}
        <div class="flex items-end gap-4">
          {@avaliacao.inserted_at |> Date.to_string()}
        </div>
        <div class="opacity-20 text-sm">
          id: {@avaliacao.id}
        </div>
      </div>
    </div>
    """
  end
end
