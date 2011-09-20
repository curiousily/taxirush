-module(taxirush).
-compile(export_all).

create_dispatcher() ->
	{ok, Pid} = dispatcher:start(),
	erlang:register(dispatcherPid, Pid),
	Pid.

loop(DispatcherPid) ->
	ClientPid = spawn(client, create_client, []),
	ClientPid ! {call_for_a_taxi, DispatcherPid},
%	io:format("Goind to sleep ~n"),
	timer:sleep(random:uniform(5000)),
	loop(DispatcherPid).

run_simulation() ->
	random:seed(now()),
	io:format("Starting simulation ~n~n"),
	DispatcherPid = create_dispatcher(),
	loop(DispatcherPid).
