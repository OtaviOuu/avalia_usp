defmodule AvaliaUspWeb.HomeLive do
  use AvaliaUspWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> assign_professores()
    |> ok()
  end

  def assign_professores(socket) do
    socket
    |> assign_async(:professores, fn ->
      {:ok, %{professores: AvaliaUsp.Professores.list_professores!()}}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <:actions></:actions>
      </.header>

      <.search_form />

      <.async_result :let={professores} assign={@professores}>
        <:loading><.loading_spinner /></:loading>
        <:failed :let={_failure}>erro ao buscar profesosres</:failed>
        <.professores_grid professores={professores} />
      </.async_result>
    </Layouts.app>
    """
  end

  defp search_form(assigns) do
    ~H"""
    <form phx-change="search" class="w-full">
      <label class="input input-bordered input-lg w-full">
        <.icon name="hero-magnifying-glass" />
        <input type="search" name="professor_search_input" placeholder="buscar professores..." />
      </label>
    </form>
    """
  end

  def handle_event("search", %{"professor_search_input" => search_term}, socket) do
    socket
    |> assign(:professores, Phoenix.LiveView.AsyncResult.loading())
    |> start_async(:search_professores, fn ->
      AvaliaUsp.Professores.search_professores!(search_term)
    end)
    |> noreply()
  end

  def handle_async(:search_professores, {:ok, result}, socket) do
    socket
    |> assign(:professores, Phoenix.LiveView.AsyncResult.ok(result))
    |> noreply()
  end

  def handle_async(:search_professores, {:error, reason}, socket) do
    socket
    |> assign(:professores, Phoenix.LiveView.AsyncResult.failed(reason))
    |> noreply()
  end

  attr :professor, AvaliaUsp.Professores.Professor, required: true

  defp professor_card(assigns) do
    ~H"""
    <div
      phx-click={JS.navigate(~p"/professores/#{@professor.nome_completo}")}
      id={"professor-card-#{@professor.id}"}
      class="card bg-base-100 border border-base-300 hover:border-primary transition cursor-pointer"
    >
      <div class="card-body gap-2">
        <div class="flex items-center justify-between">
          <h2 class="card-title text-base">
            {@professor.nome_completo}
          </h2>

          <div class="badge badge-ghost">
            {@professor.media_avaliacoes}
          </div>
        </div>

        <p class="opacity-60 truncate">
          {@professor.email}
        </p>

        <div class="flex items-center gap-2 mt-2">
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

  attr :professores, :list, required: true

  defp professores_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-3 gap-4 ">
      <.professor_card :for={professor <- @professores} professor={professor} />
    </div>
    """
  end
end
