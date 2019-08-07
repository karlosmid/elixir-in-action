defmodule TodoList do
  defstruct auto_id: 1, entries: %{}
  def new, do: %TodoList{}
  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end
  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end
  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list
      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
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