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
    resource AvaliaUsp.Universidades.DisciplinaProfessor
    resource AvaliaUsp.Universidades.Faculdade
  end
end
