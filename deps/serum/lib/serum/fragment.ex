defmodule Serum.Fragment do
  @moduledoc """
  Defines a struct representing a page fragment.

  ## Fields

  * `file`: Source path. This can be `nil` if created internally.
  * `output`: Destination path
  * `metadata`: A map holding extra information about the fragment
  * `data`: Contents of the page fragment
  """

  alias Serum.Plugin

  @type t :: %__MODULE__{
          file: binary() | nil,
          output: binary(),
          metadata: map(),
          data: binary()
        }

  defstruct [:file, :output, :metadata, :data]

  @doc "Creates a new `Fragment` struct."
  @spec new(binary() | nil, binary(), map(), binary()) :: Result.t(t())
  def new(file, output, metadata, data) do
    with {:ok, html_tree} <- Floki.parse_document(data),
         {:ok, html_tree} <- preprocess(html_tree, metadata) do
      fragment = %__MODULE__{
        file: file,
        output: output,
        metadata: Map.put(metadata, :images, extract_images(html_tree)),
        data: Floki.raw_html(html_tree)
      }

      {:ok, fragment}
    else
      {:error, _} = error -> error
    end
  end

  @spec preprocess(Floki.html_tree(), map()) :: Result.t(Floki.html_tree())
  defp preprocess(html_tree, metadata) do
    html_tree
    |> Floki.traverse_and_update(%{}, &set_header_ids/2)
    |> elem(0)
    |> Plugin.rendering_fragment(metadata)
  end

  @spec set_header_ids(Floki.html_tag(), map()) :: {Floki.html_tag(), map()}
  defp set_header_ids(tree, state)

  defp set_header_ids({<<?h, ch::8>>, _, _} = tree, state) when ch in ?1..?6 do
    {tag_name, attrs, children} = tree

    case Enum.find(attrs, fn {k, _} -> k === "id" end) do
      {"id", id} ->
        {tree, increase_count(state, id)}

      nil ->
        id = generate_id(tree)

        new_tree =
          case state[id] do
            nil -> {tag_name, [{"id", id} | attrs], children}
            x -> {tag_name, [{"id", "#{id}-#{x + 1}"} | attrs], children}
          end

        {new_tree, increase_count(state, id)}
    end
  end

  defp set_header_ids(tree, state), do: {tree, state}

  @spec generate_id(Floki.html_tag()) :: binary()
  defp generate_id(tree) do
    [tree]
    |> Floki.text()
    |> String.downcase()
    |> String.replace(~r/\s/, "-")
  end

  @spec increase_count(map(), binary()) :: map()
  defp increase_count(map, id), do: Map.update(map, id, 1, &(&1 + 1))

  @spec extract_images(Floki.html_tree()) :: [binary()]
  defp extract_images(tree) do
    tree
    |> Floki.find("img")
    |> Enum.map(fn {"img", attrs, _} ->
      attrs |> Enum.find(fn {k, _} -> k === "src" end) |> elem(1)
    end)
    |> List.flatten()
  end

  defprotocol Source do
    @moduledoc false

    alias Serum.Result

    @spec to_fragment(term()) :: Result.t(Fragment.t())
    def to_fragment(x)
  end
end
