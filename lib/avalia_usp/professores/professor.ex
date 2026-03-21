defmodule AvaliaUsp.Professores.Professor do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Professores,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "professores"
    repo AvaliaUsp.Repo
  end
end
