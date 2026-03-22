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

    read :search do
      argument :search_term, :string do
        description "Termo de busca para nome ou email do professor"
        allow_nil? true
        public? true
      end

      filter expr(
        ilike(primeiro_nome, "%" <> ^arg(:search_term) <> "%") or
        ilike(sobrenome, "%" <> ^arg(:search_term) <> "%") or
        ilike(email, "%" <> ^arg(:search_term) <> "%")
      )
    end
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


  preparations do
    prepare build(load: [:nome_completo])
  end

  calculations do
    calculate :nome_completo, :string, expr(primeiro_nome <> " " <> sobrenome)
  end
end
