defmodule AvaliaUspWeb.ProfessoresLive.Show do
  use AvaliaUspWeb, :live_view
  use Cinder.UrlSync

  def mount(%{"professor_nome" => professor_nome}, _session, socket) do
    socket
    |> assign(:page_title, "Avaliações para #{professor_nome}")
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
          <.button class="btn btn-secundary" phx-click={JS.navigate(~p"/avaliar/#{@professor_nome}")}>
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
        click={
          fn avaliacao ->
            JS.navigate(~p"/professores/#{@professor_nome}/avaliacoes/#{avaliacao.id}")
          end
        }
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
        <:col field="comentario" search />
        <:col
          field="disciplina.nome"
          name="Disciplina"
          search
          filter={[
            type: :select,
            label: "Filtrar por disciplina",
            prompt: "Selecione uma disciplina",
            options:
              Enum.map(@professor.result.disciplinas, fn disciplina ->
                {disciplina.nome, disciplina.nome}
              end),
            match_mode: :any
          ]}
        />
        <:item :let={avaliacao}>
          <.avaliacao_details_card avaliacao={avaliacao} />
        </:item>
      </Cinder.collection>
    </Layouts.app>
    """
  end
end
