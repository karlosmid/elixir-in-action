run_query =
  fn query_def ->
    Process.sleep(2000)
    "#{query_def} result"
  end
  async_query =
    fn query_def ->
      spawn(fn query_def ->
      IO.puts(run_query.(query_def))
      end)
    end