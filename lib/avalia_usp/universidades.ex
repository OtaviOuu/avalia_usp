defmodule AvaliaUsp.Universidades do
  use Ash.Domain,
    otp_app: :avalia_usp,
    extensions: [AshGraphql.Domain, AshJsonApi.Domain, AshAdmin.Domain]

  json_api do
    routes do
      base_route "/disciplinas", AvaliaUsp.Universidades.Disciplina do
        index :read
      end
    end
  end

  admin do
    show? true
  end

  resources do
    resource AvaliaUsp.Universidades.Universidade
    resource AvaliaUsp.Universidades.Disciplina

    resource AvaliaUsp.Universidades.DisciplinaProfessor do
      define :associar_disciplina_no_professor,
        action: :create,
        args: [:professor_id, :disciplina_id]
    end

    resource AvaliaUsp.Universidades.Faculdade
  end
end
