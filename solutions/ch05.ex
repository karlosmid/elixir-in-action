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
    