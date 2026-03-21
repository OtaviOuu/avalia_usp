defmodule AvaliaUsp.Professores do
  use Ash.Domain,
    otp_app: :avalia_usp

  resources do
    resource AvaliaUsp.Professores.Professor
  end
end
