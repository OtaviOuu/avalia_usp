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
      |> to_form()

    disciplinas_options = prof.disciplinas |> Enum.map(&{&1.nome, &1.id})

    socket
    |> assign(actor: current_user)
    |> assign(form: form)
    |> assign(professor_nome: professor_nome)
    |> assign(disciplinas_options: disciplinas_options)
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <.return_to link={~p"/professores/#{@professor_nome}"} />
      </.header>
      <.form for={@form} phx-submit="submit">
        <.input field={@form[:nota]} type="number" placeholder="Nota" />
        <.input field={@form[:comentario]} type="textarea" placeholder="Comentário" />
        <.input
          field={@form[:disciplina_id]}
          type="select"
          options={@disciplinas_options}
        />

        <.button>
          Avaliar
        </.button>
      </.form>
    </Layouts.app>
    """
  end

  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form,
           params: %{avaliacao_attrs: params},
           actor: socket.assigns.current_user
         ) do
      {:ok, _} ->
        socket
        |> put_flash(:info, "Avaliação feita com sucesso")
        |> push_navigate(to: ~p"/")
        |> noreply()

      {:error, form} ->
        case form.errors do
          [avaliador_id: _] ->
            socket
            |> put_flash(:error, "Você já avaliou esse professor")
            |> assign(:form, form)
            |> noreply()

          _ ->
            dbg(form)

            socket
            |> put_flash(:error, "Erro ao avaliar professor, confira os erros abaixo")
            |> assign(:form, form)
            |> noreply()
        end
    end
  end
end
