function connect_table = createConnectTable(N)
  connect_table = [];

  for i = 1:(N-1)
    start = i * 2 - 1;
    connect_table = [connect_table; [start, start+1; start, start+2; start, start+3; start + 1, start + 3]];
  end
  connect_table = [connect_table; [2 * N - 1, 2 * N]];
end

