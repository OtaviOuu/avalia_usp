defmodule AvaliaUsp.Universidades.Universidade do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Universidades,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "universidades"
    repo AvaliaUsp.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:nome]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :nome, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    has_many :faculdades, AvaliaUsp.Universidades.Faculdade do
      source_attribute :id
      destination_attribute :universidade_id
    end
  end
end
