defmodule TodoList do
  def new, do: MultiDict.new()
  def add_entry(todo_list, entry) do
    MultiDict.add(todo_list, entry.date, entry)
  end
  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end
defmodule MultiDict do
  def new, do: %{}
  def add(dict, key, value) do
    Map.update(dict, key, [value], &[value | &1])
  end
  def get(dict, key) do
    Map.get(dict, key, [])
  end
end
defmodule Fraction do
  defstruct a: nil, b: nil
  def new(a, b), do: %Fraction{a: a, b: b}
  def value(%Fraction{a: a, b: b}), do: a/b
  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}), do: new(a1*b2+a2*b1, b2*b1)
end