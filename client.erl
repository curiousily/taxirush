-module(client).
-compile(export_all).

create_client() ->
	receive
		{call_for_a_taxi, DispatcherPid} ->
			call_for_a_taxi(DispatcherPid, get_random_client_name())	
	end.

call_for_a_taxi(DispatcherPid, Client) ->
	io:format("~p is calling for a taxi~n", [Client]),
	dispatcher:receive_call(DispatcherPid, self(),  Client),
	receive
		{taxi_not_available} ->
			timer:sleep(10000),
			io:format("Trying after no taxi available"),
			call_for_a_taxi(DispatcherPid, Client);	
		{success} ->
		ok
	end.

get_random_client_name() ->
	NameList = ["Anna", "Adam", "Tom", "Angel", "Google", "Facebook", "Britney", "Jerry", "Nicolas", "Ivan", "Georgi", "Tihomir", "Filip", "Atanas"],
	ShuffledNames = list_utils:shuffle_list(NameList),
	lists:nth(1, ShuffledNames).
