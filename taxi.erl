-module(taxi).

-compile(export_all).

start_working() ->
	DispatcherPid = rpc:call('dispatcher@vini.bg', erlang, whereis, [dispatcherPid]),
	TaxiPid = spawn(taxi, receive_job,[]),
	dispatcher:taxi_is_available(DispatcherPid, TaxiPid).

receive_job() ->
	receive
		{job_offer, Pid, Client} ->
%			io:format("Received job offer~n"),
			receive_job_offer(Client),
			timer:sleep(5000),
			deliver_client(Client),
%			io:format("Taxi is available again~n"),
			dispatcher:taxi_is_available(Pid, self())
	end,
	receive_job().

receive_job_offer(Client) ->
	io:format("Job taken from dispatcher for client: ~p~n", [Client]).

deliver_client(Client) ->
	io:format("Client ~p is delivered to the destionation~n", [Client]).
