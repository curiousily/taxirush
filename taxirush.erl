-module(taxirush).
-compile(export_all).

create_dispatcher() ->
	{ok, Pid} = dispatcher:start(),
	Pid.

loop(DispatcherPid) ->
	ClientPid = spawn(client, create_client, []),
	ClientPid ! {call_for_a_taxi, DispatcherPid},
%	io:format("Goind to sleep ~n"),
	timer:sleep(2000),
	loop(DispatcherPid).

run_simulation() ->
	io:format("Starting simulation ~n~n"),
	DispatcherPid = create_dispatcher(),
	loop(DispatcherPid).
