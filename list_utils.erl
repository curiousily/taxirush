-module(list_utils).
-compile(export_all).

shuffle_list(List) ->                                          
   random:seed(now()),
   {NewList, _} = lists:foldl( fun(_El, {Acc,Rest}) ->          
       RandomEl = lists:nth( random:uniform(length(Rest)), Rest),
       {[RandomEl|Acc], lists:delete(RandomEl, Rest)}            
   end, {[],List}, List),                                        
   NewList.
