defmodule AvaliaUsp.Professores.Avaliacao do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Professores,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAdmin.Resource, AshAuthentication]

  admin do
    label_field :id
  end

  postgres do
    table "avaliacaos"
    repo AvaliaUsp.Repo
  end

  actions do
    default_accept [:nota, :comentario, :disciplina_id]
    defaults [:read, :destroy, :update]

    read :search_avaliacaoes do
      argument :professor_nome_completo, :string do
        description "Nome completo do professor para buscar avaliações"
        allow_nil? false
        public? true
      end

      filter expr(professor.nome_completo == ^arg(:professor_nome_completo))
    end

    create :create do
      accept [:nota, :comentario, :disciplina_id]
      primary? true

      validate compare(:nota, greater_than_or_equal_to: 1, less_than_or_equal_to: 10),
        message: "A nota deve ser entre 1 e 10."

      validate string_length(:comentario, max: 500)

      change relate_actor(:avaliador, field: :id)
    end
  end

  policies do
    policy action([:create]) do
      authorize_if actor_present()
    end

    policy action([:read, :destroy, :search_avaliacaoes]) do
      access_type :strict
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :nota, :integer do
      constraints min: 1, max: 10
      allow_nil? false
      public? true
    end

    attribute :comentario, :string do
      constraints max_length: 500
      public? true
      allow_nil? true
    end

    timestamps()
  end

  relationships do
    belongs_to :professor, AvaliaUsp.Professores.Professor do
      destination_attribute :id
      source_attribute :professor_id
      allow_nil? false
      public? true
    end

    belongs_to :disciplina, AvaliaUsp.Universidades.Disciplina do
      destination_attribute :id
      source_attribute :disciplina_id
      public? true
    end

    belongs_to :avaliador, AvaliaUsp.Accounts.User do
      destination_attribute :id
      source_attribute :avaliador_id
      allow_nil? false
      public? true
    end
  end

  identities do
    identity :unique_avalicao_por_avaliador, [:avaliador_id, :disciplina_id, :professor_id],
      field_names: [:avaliador_id],
      message: "Você já avaliou este professor para esta disciplina."
  end
end
