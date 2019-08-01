defmodule ElixirInAction.Stream do
    def line_lenghts!(path) do
      path
      |> File.stream!
      |> Enum.map(&String.length(&1))
    end
    def longest_line_length!(path) do
      path
      |> File.stream!
      |> Stream.map(&String.length(&1))
      |> Enum.max
    end
    def longest_line!(path) do
      path
      |> File.stream!
      |> Enum.reduce("", fn x, acc ->
                          if String.length(x) > String.length(acc) do
                            x
                          else
                            acc
                          end
                        end)
    end
    def words_per_line!(path) do
      path
      |> File.stream!
      |> Stream.map(fn x -> length(String.split(x)) end)
      |> Enum.max
    end
end