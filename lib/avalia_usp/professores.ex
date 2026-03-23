defmodule AvaliaUsp.Professores do
  use Ash.Domain,
    otp_app: :avalia_usp,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource AvaliaUsp.Professores.Professor do
      define :list_professores, action: :read
      define :get_professor_by_nome_completo, action: :read, get_by: [:nome_completo]
      define :search_professores, action: :search, args: [:search_term]
    end

    resource AvaliaUsp.Professores.Avaliacao
  end
end
