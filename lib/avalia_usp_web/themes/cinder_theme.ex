defmodule AvaliaUspWeb.Themes.CinderTheme do
  use Cinder.Theme
  extends :daisy_ui

  set :container_class, "container mx-auto card bg-base-100 border border-base-300 shadow-sm"

  set :filter_container_class,
      ""

  set :sort_container_class, ""

  set :controls_class,
      "mb-6 !flex !flex-col"

  set :grid_item_clickable_class,
      "cursor-pointer hover:shadow-md transition-shadow"

  set :grid_selection_overlay_class, "mb-2"
end
