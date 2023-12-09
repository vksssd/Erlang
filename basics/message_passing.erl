-module(message_passing).
-export([start_server/0, client/1]).

start_server()->
    spawn(fun server/0).

% server()->
%     receive
%         {From,Message}->
%             From ! {self(), "Server received: "++ Message},
%             server();
%         stop ->
%             io:format("Server stopping.~n")
% end.

% client(ServerPid)->
%     ServerPid ! {self(), "Hello from the client."},
%     receive
%         {ServerPid, Reply} -> io:format("Client received: ~p~n",[Reply])
% end,
% ServerPid ! stop.

server() ->
    receive
        {broadcast, Message} ->
            io:format("Broadcasting: ~p~n",[Message]),
            broadcast(Message),
            server();
        {From, Message}->
            From ! {self(), "Server received: "++Message},
            server();
        stop ->
            io:format("Stoping server.~n")
end.

% broadcast(Message)->
%     lists:foreach(fun(Pid) -> Pid ! {broadcast, Message} end, registered()).

broadcast(Message) ->
    Clients = [Pid || Pid <- registered(), is_client(Pid)],
    lists:foreach(fun(Pid) -> Pid ! {broadcast, Message} end, Clients).

is_client(Pid) ->
    case whereis(Pid) of
        undefined -> false;
        _ -> true
    end.


client(ServerPid)->
    ServerPid ! {self(),"Hello from client."},
    receive
        {ServerPid, Reply} -> io:format("Client received: ~p~n", [Reply]);
        {broadcast, BroadcastMsg} -> io:format("Broadcast message: ~p~n", [BroadcastMsg])
    end,

ServerPid ! {broadcast, "This is a broadcast message."}.

