defmodule AvaliaUspWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use AvaliaUspWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar bg-base-100 shadow-sm">
      <div class="flex-1">
        <.link navigate={~p"/"} class="btn btn-ghost text-xl">
          <span class="text-primary">Avalia</span>
          <span class="text-secundary">USP</span>
        </.link>
      </div>

      <div class="flex-none">
        <ul class="menu menu-horizontal items-center gap-2">
          <%= if @current_user && @current_user.is_aluno_usp? do %>
            <li class="badge badge-info">Aluno USP</li>
          <% else %>
            <li :if={@current_user} class="badge badge-warning">Não Aluno USP</li>
          <% end %>
          <.theme_toggle />
        </ul>
      </div>
    </header>

    <main class="px-4 py-10 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-2xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <div class="dropdown dropdown-end">
      <div tabindex="0" role="button" class="btn btn-ghost btn-sm gap-2">
        <.icon name="hero-swatch" class="size-4" />
        <span class="hidden sm:inline text-sm">Tema</span>
        <.icon name="hero-chevron-down" class="size-3 opacity-60" />
      </div>
      <ul
        tabindex="-1"
        class="dropdown-content bg-base-200 border border-base-300 rounded-box z-50 w-44 shadow-xl max-h-80 overflow-y-auto flex flex-col gap-0.5 p-1.5 mt-1"
      >
        <li :for={
          {label, theme} <- [
            {"Light", "light"},
            {"Cupcake", "cupcake"},
            {"Bumblebee", "bumblebee"},
            {"Emerald", "emerald"},
            {"Corporate", "corporate"},
            {"Retro", "retro"},
            {"Cyberpunk", "cyberpunk"},
            {"Valentine", "valentine"},
            {"Garden", "garden"},
            {"Lofi", "lofi"},
            {"Pastel", "pastel"},
            {"Fantasy", "fantasy"},
            {"Wireframe", "wireframe"},
            {"Cmyk", "cmyk"},
            {"Autumn", "autumn"},
            {"Acid", "acid"},
            {"Lemonade", "lemonade"},
            {"Winter", "winter"},
            {"Nord", "nord"},
            {"Caramellatte", "caramellatte"},
            {"Silk", "silk"}
          ]
        }>
          <input
            type="radio"
            name="theme-dropdown"
            class="theme-controller w-full btn btn-xs btn-block btn-ghost justify-start font-normal"
            aria-label={label}
            value={theme}
            phx-click={JS.dispatch("phx:set-theme")}
            data-phx-theme={theme}
          />
        </li>
      </ul>
    </div>
    """
  end
end
