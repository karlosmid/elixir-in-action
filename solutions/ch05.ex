run_query =
  fn query_def ->
    Process.sleep(2000)
    "#{query_def} result"
  end
  async_query =
    fn query_def ->
      caller = self()
      spawn(fn ->
        send(caller, {:query_result, run_query.(query_def)})
      end)
    end
    1..5 |> Enum.each(&async_query.("Query #{&1}"))
    get_result =
    fn ->
    receive do
      {:query_result, value} -> value
    end
    end
    1..5 |> Enum.map(fn _ -> get_result.() end)

defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end 
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end
  def get_result do
    receive do
      {:query_result, result} -> result
    after
      5000 -> {:error, :timeout}
    end
  end
  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
    loop()
    end
  end
  defp run_query(query_def) do
    Process.sleep(2000)
    "#{query_def} result."
  end
end
    