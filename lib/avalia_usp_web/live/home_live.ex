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
      {:ok, %{professores: AvaliaUsp.Professores.list_professores!(load: [:nome_completo])}}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Buscar professores e avaliações
        <:subtitle>oi</:subtitle>
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

  defp loading_spinner(assigns) do
    ~H"""
    <div class="flex items-center justify-center">
      <span class="loading loading-spinner loading-xl"></span>
    </div>
    """
  end

  defp search_form(assigns) do
    ~H"""
    <form phx-change="search" class="w-full">
      <label class="input input-bordered input-lg w-full">
        <.icon name="hero-magnifying-glass" />
        <input type="search" required placeholder="Search" />
      </label>
    </form>
    """
  end

  attr :professor, AvaliaUsp.Professores.Professor, required: true

  defp professor_card(assigns) do
    ~H"""
    <div
      id={"professor-card-#{@professor.id}"}
      class="card bg-base-100 border border-accent shadow-sm cursor-pointer"
    >
      <div class="card-body">
        <h2 class="card-title">{@professor.nome_completo}</h2>
        <%= if @professor.email do %>
          <p class="text-sm opacity-60">{@professor.email}</p>
        <% end %>
        <div class="card-actions justify-start mt-2">
          <div class="badge badge-outline">0 avaliações</div>
          <div class="badge badge-ghost">★ --</div>
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
