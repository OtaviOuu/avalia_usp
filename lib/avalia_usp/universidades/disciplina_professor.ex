defmodule AvaliaUsp.Universidades.DisciplinaProfessor do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Universidades,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "disciplina_professors"
    repo AvaliaUsp.Repo
  end

  actions do
    default_accept [:*]
    defaults [:read, :create, :destroy]
  end

  attributes do
    uuid_v7_primary_key :id

    timestamps()
  end

  relationships do
    belongs_to :disciplina, AvaliaUsp.Universidades.Disciplina do
      destination_attribute :id
      source_attribute :disciplina_id
    end

    belongs_to :professor, AvaliaUsp.Professores.Professor do
      destination_attribute :id
      source_attribute :professor_id
    end
  end
end
