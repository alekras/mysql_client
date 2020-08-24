%%
%% Copyright (C) 2011 by krasnop@bellsouth.net (Alexei Krasnopolski)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License. 
%%

%% @hidden
%% @since 2010-12-02
%% @copyright 2010-2011 Alexei Krasnopolski
%% @author Alexei Krasnopolski <krasnop@bellsouth.net> [http://crasnopolski.com/]
%% @version {@version}
%% @doc This module is running erlang unit tests.

-module(temp_debug).

%%
%% Include files
%%
-include_lib("eunit/include/eunit.hrl").
-include("client_records.hrl").
-include("mysql_types.hrl").
-include("test.hrl").

-export([zero_length_response_test/0
]).

%%
%% API Functions
%%

zero_length_response_test() ->
	?debug_Fmt(" >>> zero_length_response()",[]),
  my:start_client(),
  DS_def = #datasource{
    host = "127.0.0.1", 
    port = 3306, 
    database = "eunitdb", 
    user = "root", 
    password = "Irina_0110", 
    flags = #client_options{}
%    flags = #client_options{trans_isolation_level = serializable}
  },
  my:new_datasource(data_source, DS_def),
  ?debug_Fmt("~n before get connection!~n",[]),
  Connection = datasource:get_connection(data_source),
  ?debug_Fmt("~n after get connection~n",[]),
	Query =
				"CREATE TABLE IF NOT EXISTS subscription ("
				"client_id char(25) DEFAULT '',"
				" topic varchar(512) DEFAULT '',"
				" topic_re varchar(512),"
				" share_name varchar(128) DEFAULT '',"
				" options blob,"
				" callback blob,"
				" PRIMARY KEY (client_id, share_name, topic)"
				") ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8",
	R1 = connection:execute_query(Connection, Query),
  ?debug_Fmt("~n R1=~128p~n",[R1]),
	R2 = connection:execute_query(Connection, "REPLACE INTO subscription VALUES ('test_client','Topic','regexp','',x'8386',x'8492')"),
  ?debug_Fmt("~n R2=~128p~n",[R2]),
	R3 = connection:execute_query(Connection, "SELECT share_name, options, callback FROM subscription WHERE client_id='test_client' and topic='Topic'"),
  ?debug_Fmt("~n R3=~128p~n",[R3]),

	datasource:close(Connection)
.
