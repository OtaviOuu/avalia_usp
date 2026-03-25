defmodule AvaliaUsp.Professores do
  use Ash.Domain,
    otp_app: :avalia_usp,
    extensions: [AshAdmin.Domain, AshPhoenix]

  admin do
    show? true
  end

  resources do
    resource AvaliaUsp.Professores.Professor do
      define :list_professores, action: :read
      define :get_professor_by_nome_completo, action: :read, get_by: [:nome_completo]
      define :search_professores, action: :search, args: [:search_term]

      define :avaliar_professor,
        action: :avaliar,
        args: [:avaliacao_attrs]
    end

    resource AvaliaUsp.Professores.Avaliacao do
      define :search_avaliacoes,
        action: :search_avaliacaoes,
        args: [:professor_nome_completo]
    end
  end
end
