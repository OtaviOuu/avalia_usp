defmodule AvaliaUspWeb.PageController do
  use AvaliaUspWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
