defmodule ElixirInAction.Recursion.Range do
  def int(from, to) when is_integer(from) == :false or is_integer(to) == :false, do: "from and to must be integer."
  def int(from, to) when from == to, do: [from]
  def int(from, to) when to < from, do: []
  @spec int(integer(), integer()) :: list(integer())
  def int(from, to) do
    do_int(from+1, to, [from])
  end
  defp do_int(from, to, range) when from == to, do: [from|range] |> Enum.reverse()
  defp do_int(from, to, range) do
    do_int(from+1, to, [from|range])  
  end
end
defmodule ElixirInAction.Recursion.Len do
  def list([]) do
    0
  end

  def list([_ | tail]) do
    1 + list(tail)
  end

  def tail_list(list) do
    do_tail_list(0, list)
  end

  defp do_tail_list(len, []) do
    len
  end

  defp do_tail_list(len, [_ | tail]) do
    len = len + 1
    do_tail_list(len, tail)
  end
end
