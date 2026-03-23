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
    default_accept [:nota, :comentario]
    defaults [:read, :destroy, :update]

    create :create do
      accept [:nota, :comentario]
      primary? true

      change relate_actor(:avaliador, field: :id)
    end
  end

  policies do
    policy action([:create]) do
      authorize_if actor_present()
    end

    policy action([:read, :destroy]) do
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

    belongs_to :avaliador, AvaliaUsp.Accounts.User do
      destination_attribute :id
      source_attribute :avaliador_id
      allow_nil? false
      public? true
    end
  end
end
