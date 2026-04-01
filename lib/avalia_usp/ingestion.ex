defmodule AvaliaUsp.Ingestion do
  use Ash.Domain,
    otp_app: :avalia_usp,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource AvaliaUsp.Ingestion.Professores do
      define :scrape_professores_icmc, action: :scrape_professores_icmc
    end

    resource AvaliaUsp.Ingestion.Disciplinas do
      define :scrape_disciplinas, action: :scrape_discplinas
    end
  end
end
