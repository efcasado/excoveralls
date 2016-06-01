defmodule ExCoveralls.Html.View do
  @moduledoc """
  Conveniences for generating HTML.
  """
  require EEx
  require ExCoveralls.Html.Safe

  alias ExCoveralls.Html.Safe

  defmodule PathHelper do
    def template_path(template) do
      template |> Path.expand(get_template_path)
    end

    defp get_template_path() do
      options = ExCoveralls.Settings.get_coverage_options
      case Dict.fetch(options, "template_path") do
        {:ok, path} ->
          IO.puts("XXX template path =#{path}")
          path
        _ ->
          path0 = "#{Application.app_dir(:excoveralls)}.ez/#{Path.basename(Application.app_dir(:excoveralls))}/priv"
          path = Path.expand("templates/html/htmlcov/", path0)
        IO.puts("YYY template path =#{path}")
        path
      end
    end
  end

  @template "coverage.html.eex"

  EEx.function_from_file(:def, :render, PathHelper.template_path(@template), [:assigns])

  def partial(template, assigns \\ []) do
    EEx.eval_file(PathHelper.template_path(template), assigns: assigns)
  end

  def safe(data) do
    Safe.html_escape(data)
  end

  def coverage_class(percent) do
    cond do
      percent >= 75 -> "high"
      percent >= 50 -> "medium"
      percent >= 25 -> "low"
      true -> "terrible"
    end
  end
end
