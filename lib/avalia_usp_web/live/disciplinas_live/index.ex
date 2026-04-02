defmodule AvaliaUspWeb.DisciplinasLive.Index do
  use AvaliaUspWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Buscar Disciplinas
        <:actions>
          <.button class="btn btn-secundary" navigate={~p"/"}>
            Professores
          </.button>
        </:actions>

        <:subtitle></:subtitle>
      </.header>

      <Cinder.collection
        resource={AvaliaUsp.Universidades.Disciplina}
        theme={AvaliaUspWeb.Themes.CinderTheme}
        page_size={[default: 10, options: [10, 25, 50, 100]]}
      >
        <:col :let={disciplina} field="nome" sort search>
          {handle_disciplina_nome_display_size(disciplina.nome)}
        </:col>
        <:col :let={disciplina} field="codigo" sort search>{disciplina.codigo}</:col>
      </Cinder.collection>
    </Layouts.app>
    """
  end

  defp handle_disciplina_nome_display_size(disciplina_nome) do
    if String.length(disciplina_nome) > 60 do
      String.slice(disciplina_nome, 0..60) <> "..."
    else
      disciplina_nome
    end
  end
end
