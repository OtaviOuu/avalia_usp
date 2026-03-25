defmodule AvaliaUspWeb.ProfessoresLive.Show do
  use AvaliaUspWeb, :live_view
  use Cinder.UrlSync

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

  def handle_params(params, uri, socket) do
    socket = Cinder.UrlSync.handle_params(params, uri, socket)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <.return_to link={~p"/"} text="voltar" />
        <:actions>
          <.button phx-click={JS.navigate(~p"/avaliar/#{@professor_nome}")}>
            Avaliar Professor
          </.button>
        </:actions>
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
        url_state={@url_state}
        theme={AvaliaUspWeb.Themes.CinderTheme}
        query={
          Ash.Query.for_read(
            AvaliaUsp.Professores.Avaliacao,
            :search_avaliacaoes,
            %{
              professor_nome_completo: @professor_nome
            },
            load: [:avaliador]
          )
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
          <div class="flex-1 items-center justify-between">
            <div>
              <p class="font-medium">Nota: {avaliacao.nota}</p>
              <p class="text-sm text-gray-600">{avaliacao.comentario}</p>
              <p class="text-sm text-gray-600">{avaliacao.avaliador.email}</p>
            </div>
          </div>
        </:item>
      </Cinder.collection>
    </Layouts.app>
    """
  end
end
