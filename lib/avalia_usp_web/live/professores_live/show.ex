defmodule AvaliaUspWeb.ProfessoresLive.Show do
  use AvaliaUspWeb, :live_view

  def mount(%{"professor_nome" => professor_nome}, _session, socket) do
    socket
    |> assign_professor_details(professor_nome)
    |> ok()
  end

  def assign_professor_details(socket, professor_nome) do
    socket
    |> assign(:professor_nome, professor_nome)
    |> assign_async(:professor, fn ->
      {:ok,
       %{
         professor:
           AvaliaUsp.Professores.get_professor_by_nome_completo!(professor_nome,
             load: [:disciplinas]
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
        <:failed :let={_failure}>erro ao buscar professor</:failed>
        <.professor_details professor={professor} />
      </.async_result>
      <Cinder.collection
        :if={@professor.ok?}
        layout={:grid}
        grid_columns={1}
        theme="daisy_ui"
        query={
          Ash.Query.for_read(AvaliaUsp.Professores.Avaliacao, :search_avaliacaoes, %{
            professor_nome_completo: @professor_nome
          })
        }
      >
        <:col field="comentario" filter search />
        <:col field="nota" sort />
        <:col
          field="disciplina.nome"
          search
          filter={[
            type: :select,
            options:
              Enum.map(@professor.result.disciplinas, fn disciplina ->
                {disciplina.nome, disciplina.nome}
              end),
            match_mode: :any
          ]}
        />
        <:item :let={avaliacao}>
          <div class="flex items-center justify-between p-4 border-b">
            <div>
              <p class="font-medium">Nota: {avaliacao.nota}</p>
              <p class="text-sm text-gray-600">{avaliacao.comentario}</p>
            </div>
          </div>
        </:item>
      </Cinder.collection>
    </Layouts.app>
    """
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
            ★ {@professor.media_avaliacoes}
          </div>
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
end
