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

      define :create_professor,
        action: :create,
        args: [:nome_completo, :sobrenome, :primeiro_nome, :profile_picture_url]

      define :get_professor_by_nome_completo, action: :read, get_by: [:nome_completo]
      define :search_professores, action: :search, args: [:search_term]

      define :avaliar_professor,
        action: :avaliar,
        args: [:avaliacao_attrs]
    end

    resource AvaliaUsp.Professores.Avaliacao do
      define :create_avaliacao,
        action: :create,
        args: [:nota, :comentario, :disciplina_id, :professor_id]

      define :get_avaliacao_by_id, action: :read, get_by: [:id]
      define :like_avaliacao, action: :like
      define :dislike_avaliacao, action: :dislike

      define :search_avaliacoes,
        action: :search_avaliacaoes,
        args: [:professor_nome_completo]
    end

    resource AvaliaUsp.Professores.SolicitacaoDisciplina do
      define :list_my_solicitacoes, action: :read_my

      define :open_solicitacao,
        action: :create,
        args: [:nome_disciplina, :comentario, :links_uteis, :professor_id]
    end
  end
end
