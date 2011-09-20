-module(dispatcher).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([start/0, receive_call/3, taxi_is_available/2]).

start() -> gen_server:start_link(?MODULE, [], []).

receive_call(Pid, ClientPid, Client) ->
	gen_server:call(Pid, {receive_call, ClientPid, Client}).

taxi_is_available(Pid, TaxiPid) ->
	gen_server:call(Pid, {taxi_is_available, TaxiPid}).

%gen_taxi_list(Taxies, 0) ->
%	Taxies;

%gen_taxi_list(Taxies, Number) ->
%	Pid = spawn(taxi, receive_job, []),
%	gen_taxi_list([Pid | Taxies], Number - 1).

% gen server functions

init([]) ->
	%Taxies = gen_taxi_list([], 50),
	{ok, []}.

handle_call({receive_call, ClientPid, _}, _From, []) ->
	io:format("Currently taxies are not available~n"),
	ClientPid ! taxi_not_available,
	{reply, ok, []}; 


handle_call({receive_call, ClientPid, Client}, _From, Taxies) ->
	TaxiPid = get_taxi_pid(Taxies),
%	io:format("Calling taxi with PID ~p ~n", [TaxiPid]),
%	taxi:job_offer(TaxiPid, self(), Client),
	TaxiPid ! {job_offer, self(), Client},
	NewTaxies = lists:delete(TaxiPid, Taxies),
	%io:format("Removed taxi pid: ~p~n", [TaxiPid]),
	ClientPid ! success,
	{reply, ok, NewTaxies};

handle_call({taxi_is_available, TaxiPid}, _From, Taxies) ->
%	io:format("Adding back taxi pid: ~p~n", [TaxiPid]),
	NewTaxies = [TaxiPid | Taxies],
	io:format("~nCurrently ~p taxies are available~n~n", [length(NewTaxies)]),
	{reply, ok, NewTaxies}.

handle_cast(_Message, Taxies) -> {noreply, Taxies}.
handle_info(_Message, Taxies) -> {noreply, Taxies}.
terminate(_Reason, _Taxies) -> ok.
code_change(_OldVersion, Taxies, _Extra) -> {ok, Taxies}.

get_taxi_pid(Taxies) ->
	ShuffledTaxies = list_utils:shuffle_list(Taxies),
	lists:nth(1, ShuffledTaxies).
