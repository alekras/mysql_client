%% @author alexeikrasnopolski
%% @doc @todo Add description to testing.


-module(testing).
%%-include_lib("eunit/include/eunit.hrl").
-include("client_records.hrl").
-include("test.hrl").

%%
%% API functions
%%
-export([do_setup/1, do_cleanup/2, do_start/0, do_stop/1]).

do_start() ->
  R = my:start_client(),
  ?debug_Fmt(">>> start app return: ~p",[R]).

do_stop(_R) ->
  R = my:stop_client(),
  ?debug_Fmt("<<< stop app return: ~p",[R]).

do_setup({plain, 'DB_create_Table_create'} = X) ->
%  ?debug_Fmt("setup test: ~p", [X]), 
  Database = "eunitdb", %% TODO check it!
  DS_def = #datasource{
%    name = datasource,
    host = ?TEST_SERVER_HOST_NAME, 
    port = ?TEST_SERVER_PORT, 
    database = Database, %"eunitdb", 
    user = ?TEST_USER, 
    password = ?TEST_PASSWORD, 
    flags = set(X)
  },
  {ok, Pid} = my:new_datasource(datasource, DS_def, [{test_on_borrow, true},{max_wait, 100}]),
  Pid;
do_setup(X) ->
%  ?debug_Fmt("setup test: ~p", [X]), 
  Database = "eunitdb", %% TODO check it!
  DS_def = #datasource{
%    name = datasource,
    host = ?TEST_SERVER_HOST_NAME, 
    port = ?TEST_SERVER_PORT, 
    database = Database, %"eunitdb", 
    user = ?TEST_USER, 
    password = ?TEST_PASSWORD, 
    flags = set(X)
  },
  {ok, Pid} = my:new_datasource(datasource, DS_def, [{test_on_borrow, true},{max_wait, 100}]),
  Pid.

set({plain, _}) -> #client_options{};
set({compress, _}) -> #client_options{compress = 1}.

do_cleanup(_X, _Pid) ->
%  ?debug_Fmt("teardown after: ~p ~p~n",[_X, _Pid]),
  datasource:close(datasource).
