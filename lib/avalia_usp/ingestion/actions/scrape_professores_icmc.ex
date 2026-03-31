defmodule AvaliaUsp.Ingestion.Actions.ScrapeProfessoresIcmc do
  use Ash.Resource.Actions.Implementation

  # url errada

  @domain "https://www.icmc.usp.br"
  @url @domain <> "/templates/icmc2015/php/pessoas.php"

  def run(_input, _opts, _ctx) do
    attrs = profs_attrs()

    Ash.bulk_create(attrs, AvaliaUsp.Professores.Professor, :create,
      authorize?: false,
      stop_on_error?: false,
      return_errors?: false
    )

    {:ok, attrs}
  end

  defp profs_attrs() do
    Enum.map(1..6, fn index ->
      get_prof_data_from_page(index)
    end)
    |> List.flatten()
  end

  defp get_prof_data_from_page(page) do
    url_with_page = @url <> "?page=" <> Integer.to_string(page)
    dbg(url_with_page)

    Req.get!(url_with_page).body
    |> Floki.parse_document!()
    |> Floki.find(".foto.foto_esquerda a")
    |> Enum.map(&get_professor_attr/1)
  end

  defp get_professor_attr(html_tree_professor) do
    professor_nome_completo =
      html_tree_professor
      |> Floki.attribute("title")
      |> List.first()
      |> String.trim()

    professor_sobrenome =
      professor_nome_completo
      |> String.split()
      |> Enum.drop(1)
      |> Enum.join(" ")

    professor_primeiro_nome =
      professor_nome_completo
      |> String.split()
      |> List.first()

    professor_image =
      html_tree_professor
      |> Floki.find("img")
      |> Floki.attribute("src")
      |> List.first()

    %{
      primeiro_nome: professor_primeiro_nome,
      profile_picture_url: professor_image,
      sobrenome: professor_sobrenome
    }
  end

  defp parse_prof(prof_href) do
    Req.get!(@domain <> prof_href).body
    |> Floki.parse_document!()
    |> Floki.find("img.img-responsive.img-thumbnail")
    |> Floki.attribute("src")
  end
end
