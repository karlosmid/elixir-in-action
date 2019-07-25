defmodule ElixirInAction.Recursion do
  def list_len([]) do
    0
  end

  def list_len([_ | tail]) do
    1 + list_len(tail)
  end

  def tail_list_len(list) do
    do_tail_list_len(0, list)
  end

  defp do_tail_list_len(len, []) do
    len
  end

  defp do_tail_list_len(len, [_ | tail]) do
    len = len + 1
    do_tail_list_len(len, tail)
  end
end
