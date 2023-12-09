-module(higher_order).
-export([apply_twice/2]).

apply_twice(Fun,Arg)->
    Fun(Fun(Arg)).