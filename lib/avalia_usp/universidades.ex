defmodule AvaliaUsp.Universidades do
  use Ash.Domain,
    otp_app: :avalia_usp,
    extensions: [AshAdmin.Domain]

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
