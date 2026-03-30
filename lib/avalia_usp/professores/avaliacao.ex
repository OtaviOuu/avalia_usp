defmodule AvaliaUsp.Professores.Avaliacao do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Professores,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAdmin.Resource, AshAuthentication, AshPhoenix, AshCloak, AshRateLimiter]

  rate_limit do
    backend AvaliaUsp.Hammer

    action :like,
      limit: 5,
      per: :timer.minutes(2),
      key: fn changeset, context ->
        "user:#{context.actor.id}:like"
      end

    action :dislike,
      limit: 5,
      per: :timer.minutes(2),
      key: fn changeset, context ->
        "user:#{context.actor.id}:dislike"
      end
  end

  admin do
    label_field :id
  end

  postgres do
    table "avaliacaos"
    repo AvaliaUsp.Repo
  end

  cloak do
    vault(AvaliaUsp.Vault)

    attributes([:comentario])

    decrypt_by_default([:comentario])
  end

  actions do
    default_accept [:nota, :comentario, :disciplina_id]
    defaults [:destroy, :update]

    read :read do
      primary? true

      pagination required?: false, offset?: true, keyset?: true
    end

    read :search_avaliacaoes do
      argument :professor_nome_completo, :string do
        description "Nome completo do professor para buscar avaliações"
        allow_nil? false
        public? true
      end

      filter expr(professor.nome_completo == ^arg(:professor_nome_completo))

      pagination required?: false, offset?: true, keyset?: true
    end

    create :create do
      accept [
        :nota,
        :comentario,
        :disciplina_id,
        :professor_id,
        :cobra_presenca,
        :comentario_avaliacao,
        :comentario_presenca
      ]

      primary? true

      validate present(:nota),
        message: "A nota é obrigatória."

      validate compare(:nota, greater_than_or_equal_to: 1, less_than_or_equal_to: 10),
        message: "A nota deve ser entre %{greater_than_or_equal_to} e %{less_than_or_equal_to}."

      validate present(:comentario),
        message: "O comentário é obrigatório."

      validate string_length(:comentario, max: 500, min: 10),
        message: "O comentário deve ter entre %{min} e %{max} caracteres."

      validate string_length(:comentario_avaliacao, max: 500),
        message: "O comentário sobre avaliação deve ter no máximo %{max} caracteres."

      validate string_length(:comentario_presenca, max: 500),
        message: "O comentário sobre presença deve ter no máximo %{max} caracteres."

      change(relate_actor(:avaliador, field: :id))
    end

    update :like do
      require_atomic? false
      change atomic_update(:likes, expr(likes + 1))
    end

    update :dislike do
      require_atomic? false

      change atomic_update(:likes, expr(likes - 1))
    end
  end

  policies do
    policy action([:create, :like, :dislike]) do
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
      allow_nil? false
    end

    attribute :comentario_avaliacao, :string do
      allow_nil? true
      public? true
    end

    attribute :comentario_presenca, :string do
      allow_nil? true
      public? true
    end

    attribute :likes, :integer do
      default 0
      public? true
    end

    attribute :cobra_presenca, :boolean do
      allow_nil? false
      public? true
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
