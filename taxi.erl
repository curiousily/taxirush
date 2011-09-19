-module(taxi).
-compile(export_all).

receive_job() ->
	receive
		{job_offer, Pid, Client} ->
%			io:format("Received job offer~n"),
			receive_job_offer(Client),
			% should wait some time before doing this
			deliver_client(Client),
%			io:format("Taxi is available again~n"),
			dispatcher:taxi_is_available(Pid, self())
	end,
	receive_job().

receive_job_offer(Client) ->
	io:format("Job taken from dispatcher for client: ~p~n", [Client]).

deliver_client(Client) ->
	timer:sleep(20000),
	io:format("Client ~p is delivered to the destionation~n", [Client]).
