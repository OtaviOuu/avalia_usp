defmodule AvaliaUspWeb.Themes.CinderTheme do
  use Cinder.Theme
  extends :daisy_ui

  # Container
  set :container_class, "container mx-auto"

  # Tabela
  set :table_wrapper_class, "overflow-x-auto -mx-2 sm:mx-0"
  set :table_class, "w-full border-collapse min-w-full"
  set :thead_class, "bg-base-200"
  set :header_row_class, "border-b border-base-300"

  set :th_class,
      "text-left whitespace-nowrap px-2 py-2 sm:px-4 sm:py-3 text-sm font-semibold text-base-content"

  set :tbody_class, "divide-y divide-base-200"
  set :row_class, "hover:bg-base-200 transition-colors"
  set :td_class, "px-2 py-2 sm:px-4 sm:py-3 text-sm text-base-content"
  set :selected_row_class, "bg-primary/20"

  # Controls
  set :controls_class, "mb-4 sm:mb-6 flex flex-col gap-3 sm:gap-4"

  # Filtros
  set :filter_container_class,
      "card bg-base-100 border border-base-300  p-3 shadow-sm sm:p-4 lg:p-6"

  set :filter_header_class,
      "flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 mb-3"

  set :filter_title_class, "text-sm sm:text-base font-semibold text-base-content"
  set :filter_inputs_class, "flex flex-wrap gap-3 sm:gap-4"
  set :filter_input_wrapper_class, "flex flex-col gap-1"
  set :filter_label_class, "text-xs sm:text-sm font-medium text-base-content/60"
  set :filter_text_input_class, "w-full"

  set :filter_number_input_class,
      "w-full [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none [-moz-appearance:textfield]"

  set :filter_date_input_class, "w-full"

  # Multiselect
  set :filter_multiselect_container_class, "relative"

  set :filter_multiselect_dropdown_class,
      "absolute z-50 mt-1 w-full bg-base-100 border border-base-300 rounded-lg shadow-lg max-h-60 overflow-auto p-2"

  set :filter_multiselect_option_class,
      "flex items-center gap-2 px-2 py-1.5 rounded hover:bg-base-200 cursor-pointer"

  set :filter_multiselect_checkbox_class, "checkbox checkbox-sm checkbox-primary"
  set :filter_multiselect_label_class, "text-sm text-base-content cursor-pointer"
  set :filter_multiselect_empty_class, "text-sm text-base-content/40 p-2"

  # Radio group
  set :filter_radio_group_container_class, "flex flex-wrap gap-2 sm:gap-3"
  set :filter_radio_group_option_class, "flex items-center gap-1.5"
  set :filter_radio_group_radio_class, "radio radio-sm radio-primary"
  set :filter_radio_group_label_class, "text-sm text-base-content cursor-pointer"

  # Checkbox
  set :filter_checkbox_container_class, "flex items-center gap-2"
  set :filter_checkbox_input_class, "checkbox checkbox-sm checkbox-primary"
  set :filter_checkbox_label_class, "text-sm text-base-content cursor-pointer"

  # Multicheckboxes
  set :filter_multicheckboxes_container_class, "flex flex-row gap-3"
  # set :filter_multicheckboxes_option_class, "flex items-center gap-1.5"
  # set :filter_multicheckboxes_checkbox_class, "checkbox checkbox-sm checkbox-primary"
  # set :filter_multicheckboxes_label_class, "text-sm text-base-content cursor-pointer"

  # Range
  set :filter_range_container_class,
      "flex flex-row  sm:flex-row items-stretch sm:items-center"

  set :filter_range_input_group_class, "input flex items-center"

  set :filter_range_separator_class,
      "hidden sm:flex items-center px-2 text-sm text-base-content/40"

  # Toggle e clear
  set :filter_toggle_class,
      "btn btn-ghost btn-sm gap-1 text-base-content/60 hover:text-base-content"

  set :filter_toggle_icon_class, "w-4 h-4"
  set :filter_clear_button_class, "btn btn-ghost btn-xs text-error hover:bg-error/10"
  set :filter_clear_all_class, "btn btn-ghost btn-sm text-error hover:bg-error/10"
  set :filter_count_class, "badge badge-sm badge-primary"

  # Sort
  set :sort_container_class, "bg-base-200 border border-base-300 rounded-lg"

  set :sort_controls_class,
      "flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-3 p-3 sm:p-4"

  set :sort_controls_label_class, "text-sm font-medium text-base-content/60"
  set :sort_buttons_class, "flex flex-wrap gap-1 sm:gap-2"
  set :sort_button_class, "btn btn-xs sm:btn-sm transition-colors"
  set :sort_button_inactive_class, "btn-ghost"
  set :sort_button_active_class, "btn-primary"
  set :sort_indicator_class, "ml-1 inline-flex items-center align-baseline"
  set :sort_arrow_wrapper_class, "inline-flex items-center"
  set :sort_icon_class, "ml-0.5 sm:ml-1"
  set :sort_asc_icon_class, "w-3 h-3"
  set :sort_desc_icon_class, "w-3 h-3"
  set :sort_none_icon_class, "w-3 h-3 opacity-50"
  set :sort_asc_icon_name, "hero-chevron-up"
  set :sort_desc_icon_name, "hero-chevron-down"
  set :sort_none_icon_name, "hero-chevron-up-down"

  # Busca
  set :search_input_class,
      "input input-bordered input-sm sm:input-md w-full sm:w-64 lg:w-80 focus:input-primary"

  set :search_icon_class, ""

  # Grid
  set :grid_container_class, "flex flex-col gap-4 sm:gap-6"

  set :grid_item_class,
      "card"

  set :grid_item_clickable_class,
      "cursor-pointer hover:shadow-md hover:border-primary/50 transition-all"

  set :grid_selection_overlay_class, "mb-2"

  # List
  set :list_container_class, "divide-y divide-base-200"
  set :list_item_class, "py-2 sm:py-3 px-2 sm:px-4 text-base-content"
  set :list_item_clickable_class, "cursor-pointer hover:bg-base-200 transition-colors"
  set :list_selection_container_class, "mb-2"

  # Seleção
  # set :selection_checkbox_class, "checkbox checkbox-sm checkbox-primary"

  #  set :selected_item_class, "bg-primary/20"

  # Bulk actions
  set :bulk_actions_container_class,
      "p-3 sm:p-4 bg-base-200 border border-base-300 rounded-lg flex flex-col sm:flex-row gap-2 sm:justify-end"

  # Botões
  set :button_class, "btn btn-sm"
  set :button_primary_class, "btn-primary"
  set :button_secondary_class, "btn-ghost"
  set :button_danger_class, "btn-error"
  set :button_disabled_class, "btn-disabled"

  # Paginação
  # set :pagination_wrapper_class, "mt-4 sm:mt-6"

  # set :pagination_container_class,
  # "flex flex-col sm:flex-row items-center justify-between gap-3 sm:gap-4"

  # set :pagination_info_class, "text-xs sm:text-sm text-base-content/60 order-2 sm:order-1"
  # set :pagination_count_class, "text-xs sm:text-sm text-base-content/60"
  # set :pagination_nav_class, "join order-1 sm:order-2"
  # set :pagination_button_class, "join-item btn btn-sm"
  # set :pagination_current_class, "join-item btn btn-sm btn-primary"

  # Page size
  # set :page_size_container_class, "flex items-center gap-2 order-3"
  # set :page_size_label_class, "text-xs sm:text-sm text-base-content/60"
  # set :page_size_dropdown_container_class, "relative"
  #
  # set :page_size_dropdown_class,
  #  "absolute bottom-full mb-1 right-0 bg-base-100 border border-base-300 rounded-lg shadow-lg py-1 min-w-[4rem]"

  # set :page_size_option_class,
  #    "px-3 py-1.5 text-sm text-base-content hover:bg-base-200 cursor-pointer"

  # set :page_size_selected_class, "bg-primary/20 text-primary"

  # Loading
  # set :loading_container_class, "relative min-h-[200px]"

  # set :loading_overlay_class,
  "absolute inset-0 bg-base-100/80 flex items-center justify-center z-10"

  # set :loading_spinner_class, "loading loading-spinner loading-lg text-primary"

  # Empty / erro
  set :empty_class, "text-center text-base-content/40"
  set :error_container_class, "alert alert-error"
  set :error_message_class, "text-sm"
end
