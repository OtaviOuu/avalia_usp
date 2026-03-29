defmodule AvaliaUspWeb.AvaliacoesLive.Show do
  use AvaliaUspWeb, :live_view

  def mount(
        %{"professor_nome" => professor_nome, "avaliacao_id" => avaliacao_id},
        _session,
        socket
      ) do
    socket
    |> assign(:page_title, "Avaliação para #{professor_nome}")
    |> assign(:professor_nome, professor_nome)
    |> assign_avaliacao(avaliacao_id)
    |> ok
  end

  defp assign_avaliacao(socket, avaliacao_id) do
    professor_nome = socket.assigns.professor_nome

    socket
    |> assign_async(:avaliacao, fn ->
      AvaliaUsp.Professores.get_professor_by_nome_completo!(professor_nome)

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
        <:actions :if={@avaliacao.ok?}>
          <.button phx-click="like" class="btn btn-secundary">
            <.icon name="hero-hand-thumb-up" />
          </.button>
          <.button phx-click="dislike" class="btn btn-secundary">
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
            {@avaliacao.disciplina.codigo}
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("like", _params, socket) do
    current_user = socket.assigns.current_user
    avaliacao = socket.assigns.avaliacao.result

    case AvaliaUsp.Professores.like_avaliacao(avaliacao, actor: current_user) do
      {:ok, _} ->
        socket
        |> assign_avaliacao(avaliacao.id)
        |> noreply()

      {:error,
       %Ash.Error.Forbidden{
         errors: [
           %AshRateLimiter.LimitExceeded{}
         ]
       }} ->
        socket
        |> put_flash(:error, "calma fí")
        |> noreply()

      {:error, %Ash.Error.Forbidden{}} ->
        socket
        |> put_flash(:error, "Você precisa estar logado para curtir uma avaliação")
        |> push_navigate(to: ~p"/register")
        |> noreply()

      {:error, _} ->
        socket
        |> put_flash(:error, "Ocorreu um erro")
        |> noreply()
    end
  end

  def handle_event("dislike", _params, socket) do
    current_user = socket.assigns.current_user
    avaliacao = socket.assigns.avaliacao.result

    case AvaliaUsp.Professores.dislike_avaliacao(avaliacao, actor: current_user) do
      {:ok, _} ->
        socket
        |> assign_avaliacao(avaliacao.id)
        |> noreply()

      {:error,
       %Ash.Error.Forbidden{
         errors: [
           %AshRateLimiter.LimitExceeded{}
         ]
       }} ->
        socket
        |> put_flash(:error, "calma fí")
        |> noreply()

      {:error, %Ash.Error.Forbidden{} = a} ->
        socket
        |> put_flash(:error, "Você precisa estar logado para deslike uma avaliação")
        |> push_navigate(to: ~p"/register")
        |> noreply()

      {:error, _} ->
        socket
        |> put_flash(:error, "Ocorreu um erro")
        |> noreply()
    end
  end
end
