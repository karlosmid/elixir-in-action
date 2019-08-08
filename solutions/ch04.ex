defmodule TodoList do
  defstruct auto_id: 1, entries: %{}
  def new(entries \\ []) do
    Enum.reduce(entries,
                %TodoList{},
                &add_entry(&2, &1)
    )
  end
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
  def delete_entry(todo_list, entry_id) do
    Map.delete(todo_list.entries, entry_id)
  end
  def build_entries() do
    [
      %{date: ~D[2019-08-06], title: "Dentist"},
      %{date: ~D[2019-08-07], title: "Shopping"},
      %{date: ~D[2019-08-06], title: "Movies"},
    ]
  end
  defimpl String.Chars, for: TodoList do
    def to_string(todo) do
      "%TodoList{ auto_id: #{todo.auto_id}, entries: [ #{todo.entries |> Stream.map(&entry_to_string/1) |> Enum.join(", ")} ]"
    end
    defp entry_to_string(entry) do
      "%{ #{elem(entry,0)}, %{ id: #{elem(entry, 1).id},date: #{elem(entry, 1).date}, title: #{elem(entry,1).title} } }"
    end
  end
  defimpl Collectable, for: TodoList do
    def into(original) do
      {original, &into_callback/2}
    end
    defp into_callback(todolist, {:cont, entry}) do
      TodoList.add_entry(todolist, entry)
    end
    defp into_callback(todolist, :done), do: todolist
    defp into_callback(_, :halt), do: :ok
  end
end
defmodule TodoList.CsvImporter do
  def import(path) do
    path
    |> File.stream!
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&parse_csv_line/1)
    |> TodoList.new
  end
  defp parse_csv_line(line) do
    splits = line
    |> String.replace("\n", "")
    |> String.split(",")
    date_list =
    Enum.at(splits, 0)
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    date =
    Date.new(Enum.at(date_list, 0), Enum.at(date_list, 1), Enum.at(date_list, 2))
    %{date: date, title: Enum.at(splits, 1)}
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