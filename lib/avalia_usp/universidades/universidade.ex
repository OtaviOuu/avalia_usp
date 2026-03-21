defmodule AvaliaUsp.Universidades.Universidade do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Universidades,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "universidades"
    repo AvaliaUsp.Repo
  end
end
