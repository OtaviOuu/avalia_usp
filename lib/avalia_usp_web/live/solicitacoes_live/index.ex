defmodule AvaliaUspWeb.SolicitacoesLive.Index do
  use AvaliaUspWeb, :live_view

  def mount(%{"professor_nome" => professor_nome}, _session, socket) do
    professor = AvaliaUsp.Professores.get_professor_by_nome_completo!(professor_nome)

    solicitacoes_em_aberto =
      AvaliaUsp.Professores.list_my_solicitacoes!(actor: socket.assigns.current_user)

    form =
      AvaliaUsp.Professores.form_to_open_solicitacao(actor: socket.assigns.current_user)
      |> to_form

    socket
    |> assign(:professor, professor)
    |> assign(:form, form)
    |> assign(:professor_nome, professor_nome)
    |> assign(:solicitacoes_em_aberto, solicitacoes_em_aberto)
    |> ok
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Nova Disciplina
        <:actions>
          <.button
            class="btn btn-secundary"
            phx-disable-with="Solicitando..."
          >
            Solicitar disciplina
          </.button>
        </:actions>
      </.header>
      <.form
        for={@form}
        phx-submit="open_solicitacao"
        class="card bg-base-100 border border-base-300 shadow-sm p-6"
      >
        <.input field={@form[:nome_disciplina]} label="Nome da disciplina" />
        <.input field={@form[:codigo]} label="Código da disciplina" />
        <.input field={@form[:descricao]} label="Descrição da disciplina" type="textarea" />
        <.button class="btn btn-primary">Abrir solicitação</.button>
      </.form>
    </Layouts.app>
    """
  end

  def handle_event("open_solicitacao", %{"form" => form_params}, socket) do
    form_params = Map.put(form_params, "professor_id", socket.assigns.professor.id)
    form = socket.assigns.form
    professor_nome = socket.assigns.professor_nome
    current_user = socket.assigns.current_user

    case AshPhoenix.Form.submit(form, params: form_params, actor: current_user) do
      {:ok, _solicitacao} ->
        socket
        |> put_flash(:info, "Solicitação aberta com sucesso!")
        |> push_navigate(to: ~p"/professores/#{professor_nome}")
        |> noreply()

      {:error, form} ->
        socket
        |> assign(:form, form)
        |> noreply
    end
  end
end
