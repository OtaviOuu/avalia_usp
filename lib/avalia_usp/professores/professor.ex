defmodule AvaliaUsp.Professores.Professor do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Professores,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "professores"
    repo AvaliaUsp.Repo
  end

  actions do
    default_accept [:*]
    defaults [:read, :create, :destroy, :update]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :primeiro_nome, :string do
      public? true
    end

    attribute :sobrenome, :string do
      public? true
    end

    attribute :email, :string do
      public? true
      allow_nil? true
    end

    timestamps()
  end

  calculations do
    calculate :nome_completo, :string, expr(primeiro_nome <> " " <> sobrenome)
  end
end
