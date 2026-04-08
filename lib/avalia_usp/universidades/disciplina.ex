defmodule AvaliaUsp.Universidades.Disciplina do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Universidades,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshAdmin.Resource]

  json_api do
    type "disciplina"

    default_fields [
      :professores
    ]

    includes :professores
  end

  admin do
    label_field :nome
  end

  postgres do
    table "disciplinas"
    repo AvaliaUsp.Repo
  end

  actions do
    default_accept [:*]
    defaults [:destroy, :create]

    read :read do
      primary? true

      pagination required?: false, offset?: true, keyset?: true

      prepare build(limit: 1000)
    end
  end

  preparations do
    prepare build(load: [:professores, :nome_completo])
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :nome, :string do
      description "Nome da disciplina"
      allow_nil? false
      public? true
    end

    attribute :codigo, :string do
      description "Código da disciplina"
      allow_nil? true
      public? true
    end

    timestamps()
  end

  relationships do
    many_to_many :professores, AvaliaUsp.Professores.Professor do
      through AvaliaUsp.Universidades.DisciplinaProfessor
      destination_attribute_on_join_resource :professor_id
      source_attribute_on_join_resource :disciplina_id
      public? true
    end
  end

  calculations do
    calculate :nome_completo, :string, expr(nome <> " - " <> codigo)
  end

  identities do
    identity :unique_nome_completo, [:codigo, :nome]
  end
end
