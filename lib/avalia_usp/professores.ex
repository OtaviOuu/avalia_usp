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
    end
  end
end
