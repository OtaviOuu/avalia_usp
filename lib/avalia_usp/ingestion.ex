defmodule AvaliaUsp.Ingestion do
  use Ash.Domain,
    otp_app: :avalia_usp

  resources do
    resource AvaliaUsp.Ingestion.Professores do
      define :scrape_professores_icmc, action: :scrape_professores_icmc
    end
  end
end
