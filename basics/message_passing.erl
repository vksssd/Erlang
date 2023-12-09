-module(message_passing).
-export([start_server/0, client/1]).

start_server()->
    spawn(fun server/0).

server()->
    receive
        {From,Message}->
            From ! {self(), "Server received: "++ Message},
            server();
        stop ->
            io:format("Server stopping.~n")
end.

client(ServerPid)->
    ServerPid ! {self(), "Hello from the client."},
    receive
        {ServerPid, Reply} -> io:format("Client received: ~p~n",[Reply])
end,
ServerPid ! stop.