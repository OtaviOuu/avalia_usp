defmodule AvaliaUsp.Ingestion.Professores do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Ingestion

  actions do
    action :scrape_professores_icmc, {:array, :map} do
      run AvaliaUsp.Ingestion.Actions.ScrapeProfessoresIcmc
    end
  end
end
