defmodule AvaliaUspWeb.ProfessoresLive.Show do
  use AvaliaUspWeb, :live_view

  def mount(%{"professor_nome" => professor_nome}, _session, socket) do
    socket
    |> assign_professor_details(professor_nome)
    |> ok()
  end

  def assign_professor_details(socket, professor_nome) do
    socket
    |> assign_async(:professor, fn ->
      {:ok, %{professor: AvaliaUsp.Professores.get_professor_by_nome_completo!(professor_nome)}}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Detalhes do Professor
        <:subtitle>sla</:subtitle>
      </.header>
      <.async_result :let={professor} assign={@professor}>
        <:loading><.loading_spinner /></:loading>
        <:failed :let={_failure}>erro ao buscar profesosre</:failed>
        <.professor_details professor={professor} />
      </.async_result>
    </Layouts.app>
    """
  end

  attr :professor, :map, doc: "O professor a ser exibido"

  defp professor_details(assigns) do
    ~H"""
    {@professor.nome_completo}
    """
  end
end
