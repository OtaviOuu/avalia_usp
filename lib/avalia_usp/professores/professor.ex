defmodule AvaliaUsp.Professores.Professor do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Professores,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAdmin.Resource, AshAuthentication]

  admin do
    label_field :nome_completo
  end

  postgres do
    table "professores"
    repo AvaliaUsp.Repo
  end

  actions do
    default_accept [:*]
    defaults [:read, :create, :destroy, :update]

    update :avaliar do
      accept []

      require_atomic? false

      argument :avaliacao_attrs, :map do
        description "Atributos para criar uma nova avaliação"
        allow_nil? false
        public? true
      end

      change manage_relationship(:avaliacao_attrs, :avaliacoes, type: :create, on_match: :update)
    end

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

  policies do
    policy action([:read, :search]) do
      authorize_if always()
    end

    policy action([:avaliar]) do
      authorize_if actor_present()
    end
  end

  preparations do
    prepare build(load: [:nome_completo])
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

  relationships do
    many_to_many :disciplinas, AvaliaUsp.Universidades.Disciplina do
      through AvaliaUsp.Universidades.DisciplinaProfessor
      destination_attribute_on_join_resource :disciplina_id
      source_attribute_on_join_resource :professor_id
    end

    has_many :avaliacoes, AvaliaUsp.Professores.Avaliacao do
      source_attribute :id
      destination_attribute :professor_id
    end
  end

  calculations do
    calculate :nome_completo, :string, expr(primeiro_nome <> " " <> sobrenome)
  end

  identities do
    identity :unique_email, [:email] do
      description "Garante que o email seja único entre os professores"
    end

    identity :unique_nome_completo, [:primeiro_nome, :sobrenome] do
      description "Garante que a combinação de primeiro nome e sobrenome seja única"
    end
  end
end
