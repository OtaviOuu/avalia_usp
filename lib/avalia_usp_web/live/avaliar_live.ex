defmodule AvaliaUspWeb.AvaliarLive do
  use AvaliaUspWeb, :live_view

  on_mount {AvaliaUspWeb.LiveUserAuth, :live_user_required}

  def mount(%{"professor_nome" => professor_nome}, _session, socket) do
    current_user = socket.assigns.current_user

    # bad, maybe turn professor_nome into a primary key
    prof =
      AvaliaUsp.Professores.get_professor_by_nome_completo!(professor_nome, load: [:disciplinas])

    form =
      prof
      |> AvaliaUsp.Professores.form_to_avaliar_professor(actor: current_user)
      # mess
      |> AshPhoenix.Form.add_form(:avaliacao_attrs)
      |> to_form()

    disciplinas_options = prof.disciplinas |> Enum.map(&{&1.nome, &1.id})
    dbg(disciplinas_options)

    if prof.disciplinas == [] do
      socket
      |> put_flash(:error, "Esse professor não tem disciplinas associadas, impossível avaliar")
      |> push_navigate(to: ~p"/professores/#{professor_nome}")
      |> ok
    else
      socket
      |> assign(actor: current_user)
      |> assign(form: form)
      |> assign(professor: prof)
      |> assign(professor_nome: professor_nome)
      |> assign(disciplinas_options: disciplinas_options)
      |> ok()
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <.return_to link={~p"/professores/#{@professor_nome}"} />
      </.header>
      <.professor_details professor={@professor} />
      <.form
        for={@form}
        phx-submit="submit"
        class="card bg-base-100 border border-base-300 shadow-sm p-6"
      >
        <.inputs_for :let={f} field={@form[:avaliacao_attrs]}>
          <.input field={f[:nota]} type="number" placeholder="Nota" />
          <.input field={f[:comentario]} type="textarea" placeholder="Comentário" />
          <.input field={f[:disciplina_id]} type="select" options={@disciplinas_options} />
        </.inputs_for>
        <.button class="btn btn-primary">Avaliar</.button>
      </.form>
    </Layouts.app>
    """
  end

  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form,
           params: params,
           actor: socket.assigns.current_user
         ) do
      {:ok, _} ->
        {disciplina_nome, _id} =
          Enum.find(socket.assigns.disciplinas_options, fn {_nome, id} ->
            id == Map.get(params["avaliacao_attrs"], "disciplina_id")
          end)

        socket
        |> put_flash(:info, "Avaliação feita com sucesso")
        |> push_navigate(
          to: ~p"/professores/#{socket.assigns.professor_nome}?disciplina.nome=#{disciplina_nome}"
        )
        |> noreply()

      {:error, form} ->
        case form.errors do
          [avaliador_id: _] ->
            socket
            |> put_flash(:error, "Você já avaliou esse professor")
            |> assign(:form, form)
            |> noreply()

          _ ->
            socket
            |> put_flash(:error, "Erro ao avaliar professor, confira os erros abaixo")
            |> assign(:form, form)
            |> noreply()
        end
    end
  end
end
