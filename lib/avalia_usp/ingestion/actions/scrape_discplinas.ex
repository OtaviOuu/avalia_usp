defmodule AvaliaUsp.Ingestion.Actions.ScrapeDiscplinas do
  use Ash.Resource.Actions.Implementation
  # https://edisciplinas.usp.br/enrol/index.php?id=100000

  @domain "https://edisciplinas.usp.br"
  @base_url @domain <> "/enrol/index.php"
  @cookie System.get_env("EDISCIPLINAS_COOKIE")
  @urls_file "urls.txt"

  def run(_action, _input, _context) do
    dbg(@cookie)

    141_397..141_598
    |> Task.async_stream(
      fn id ->
        get_disciplina_html_tree(id)
        |> scrape()
      end,
      max_concurrency: 50,
      timeout: :infinity,
      ordered: false
    )
    |> Stream.run()

    {:ok, []}
  end

  defp scrape(nil), do: :error

  defp scrape(html_tree) do
    disciplina_nome =
      html_tree
      |> Floki.find(".h2.mb-0")
      |> Floki.text()

    disciplina_name_only =
      if String.contains?(disciplina_nome, "-") do
        disciplina_nome
        |> String.split("-")
        |> List.last()
        |> String.trim()
      else
        disciplina_nome
      end

    disciplina_codigo = try_to_parse_disciplina_codigo(disciplina_nome)

    disciplina_attrs = %{
      nome: disciplina_name_only,
      codigo: disciplina_codigo
    }

    professores =
      html_tree
      |> Floki.find(".teachers li a")
      |> Enum.map(fn professor ->
        nome_completo = Floki.text(professor)

        primeiro_nome =
          nome_completo
          |> String.split()
          |> List.first()

        lasts_names =
          nome_completo
          |> String.split()
          |> Enum.drop(1)
          |> Enum.join(" ")

        attrs = %{
          sobrenome: lasts_names,
          primeiro_nome: primeiro_nome
        }

        case Ash.Changeset.for_create(AvaliaUsp.Professores.Professor, :create, attrs,
               authorize?: false
             )
             |> Ash.create() do
          {:ok, professor} ->
            professor

          {:error, err} ->
            dbg(err)
            nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    case Ash.Changeset.for_create(
           AvaliaUsp.Universidades.Disciplina,
           :create,
           disciplina_attrs,
           authorize?: false
         )
         |> Ash.create() do
      {:ok, disciplina} ->
        Enum.each(professores, fn professor ->
          AvaliaUsp.Universidades.associar_disciplina_no_professor(professor.id, disciplina.id,
            authorize?: false
          )
        end)

        :ok

      {:error, err} ->
        dbg(err)
        :error
    end
  end

  defp try_to_parse_disciplina_codigo(disciplina_name) do
    parts =
      disciplina_name
      |> String.split("-")

    if length(parts) > 0 do
      List.first(parts)
    else
      nil
    end
  end

  def get_disciplina_html_tree(id) do
    url = @base_url <> "?id=#{id}"

    ja_existe =
      File.exists?(@urls_file) and
        @urls_file
        |> File.stream!()
        |> Enum.any?(fn linha -> String.trim(linha) == url end)

    if ja_existe do
      dbg("URL já existe, pulando: #{url}")
      nil
    else
      File.write(@urls_file, url <> "\n", [:append])

      headers = [
        {"Cookie", @cookie}
      ]

      case Req.get(url,
             headers: headers,
             finch: MyFinch,
             receive_timeout: 60_000,
             pool_timeout: 60_000
           ) do
        {:ok, resp} ->
          Floki.parse_document!(resp.body)

        {:error, err} ->
          dbg(err)
          nil
      end
    end
  end
end
