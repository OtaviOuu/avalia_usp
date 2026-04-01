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
    Cinder.UrlSync.handle_params(params, uri, socket)
    |> noreply()
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
        page_size={[default: 1, options: [10, 25, 50, 100]]}
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
            type: :autocomplete,
            placeholder: "Search products...",
            label: "Disciplina",
            options:
              Enum.map(@professor.result.disciplinas, fn disciplina ->
                {disciplina.nome, disciplina.nome}
              end),
          ]}
        />
        <:col
          field="nota"
          filter={[
            type: :number_range,
            min: 0, max: 10, step: 1
          ]}
        />
        <:col
          field="avaliador.is_aluno_usp?"
          filter={[
            type: :multi_checkboxes,
            label: "Avaliador verificado?",
            options: [
              {"Sim", "true"},
              {"Não", "false"}
            ]
          ]}
        />
        <:item :let={avaliacao}>
          <.avaliacao_details_card avaliacao={avaliacao} />
        </:item>
        <:empty>
          <.avaliacao_details_card_empty />
        </:empty>
      </Cinder.collection>
    </Layouts.app>
    """
  end
end
