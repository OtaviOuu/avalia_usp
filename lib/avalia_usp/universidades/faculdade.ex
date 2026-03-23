defmodule AvaliaUsp.Universidades.Faculdade do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Universidades,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  admin do
    label_field :nome
  end

  postgres do
    table "faculdades"
    repo AvaliaUsp.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:nome, :abreviacao, :logo_url]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :nome, :string do
      allow_nil? false
      public? true
    end

    attribute :logo_url, :string do
      allow_nil? true
      public? true
    end

    attribute :abreviacao, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :universidade, AvaliaUsp.Universidades.Universidade do
      source_attribute :universidade_id
      destination_attribute :id
    end
  end
end
