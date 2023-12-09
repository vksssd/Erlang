-module(processes).
-export([start_process/1, process_function/1]).

start_process(Arg)->
    Pid = spawn(?MODULE, process_function, [Arg]),
    Pid! "Hello from the main process.",
    receive
        Msg->io:format("Received message in the main process ~p~n",[Msg])
    after 5000 ->
        io:format("Timeout reached. Exiting. ~n")
    end.

% process_function(Arg) ->
%     io:format("Process (~p) received: ~p~n",[self(), Arg]),
%     receive
%         _Msg -> io:format("Replying to the main process.~n")
% end.

process_function(Arg)->
    io:format("process (~p) received: ~p~n",[self(),Arg]),
    case Arg of 
        {numbers, NumList} ->
            Sum = lists:sum(NumList),
            io:format("sum of the numbers: ~p~n",[Sum]);
        _ ->
            io:format("Unknow type message~n")
end,
receive 
    _Msg->io:format("Replying to the main process.~n")
end.
