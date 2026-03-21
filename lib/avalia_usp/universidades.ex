defmodule AvaliaUsp.Universidades do
  use Ash.Domain,
    otp_app: :avalia_usp

  resources do
    resource AvaliaUsp.Universidades.Universidade
  end
end
