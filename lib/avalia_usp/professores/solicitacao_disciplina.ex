defmodule AvaliaUsp.Professores.SolicitacaoDisciplina do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Professores,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication, AshPhoenix]

  postgres do
    table "solicitacao_disciplinas"
    repo AvaliaUsp.Repo
  end

  actions do
    defaults [:read, :update, :destroy]
    default_accept [:nome_disciplina, :comentario, :links_uteis, :professor_id]

    read :read_my do
      filter expr(user_id == ^actor(:id))
    end

    create :create do
      accept [:nome_disciplina, :comentario, :links_uteis, :professor_id]
      primary? true

      change relate_actor(:user, field: :id)
    end
  end

  policies do
    policy action([:create, :read_my]) do
      authorize_if actor_present()
    end
  end

  validations do
    validate present(:nome_disciplina) do
      message "Nome da disciplina é obrigatório."
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :nome_disciplina, :string do
      allow_nil? false
      public? true
    end

    attribute :comentario, :string do
      allow_nil? true
      public? true
    end

    attribute :links_uteis, {:array, :string} do
      allow_nil? true
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :user, AvaliaUsp.Accounts.User do
      source_attribute :user_id
      destination_attribute :id
      public? true
    end

    belongs_to :professor, AvaliaUsp.Professores.Professor do
      source_attribute :professor_id
      destination_attribute :id
      public? true
    end
  end
end
