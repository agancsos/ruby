#!/bin/ruby
###############################################################################
# Name        : test_postgres.rb                                              #
# Author      : Abel Gancsos                                                  #
# Version     : v. 1.0.0.0                                                    #
# Description : Testing PostgreSQL connection using Ruby.                     #
###############################################################################
require "pg" # sudo gem install pg

class PostgresTest
	def initialize(params={})
		# Extract connection information from command-line parameters
		@host     = params["--host"] != nil ? params["--host"]      : "127.0.0.1";
		@port     = params["--port"] != nil ? params["--port"].to_i : 5432;
		@username = params["--user"] != nil ? params["--user"]      : "postgres";
		@password = params["--pass"] != nil ? params["--pass"]      : "postgres";
		@database = params["--db"]   != nil ? params["--db"]        : "postgres";
	end
	def invoke()
		# Ensure required fields
		throw "Host cannot be empty..."     if @host     == "";
		throw "Username cannot be empty..." if @username == "";
		throw "Password cannot be empty..." if @password == "";
		throw "Database cannot be empty..." if @database == "";

		# Connect using hashmap arguments
		# Note that the module is PG, not pg (https://www.rubydoc.info/gems/pg/PG)
		conn = PG.connect(:hostaddr => @host,
			:port     => @port,
			:user     => @username,
			:password => @password,
			:dbname   => @database);

		# List user tables
		rsp  = conn.exec("SELECT * FROM pg_tables");

		# Use list lambda to iterate results
		rsp.each { | row |
			# Count number of rows in cursor table 
			# Note that some tables are actually views, skip them with an empty list
			rsp2 = !row["tablename"].include?("sql_") ? conn.exec("SELECT 1 FROM #{row["tablename"]}") : [];

			# Print results
			puts("#{row["tablename"]} (#{rsp2.count})");
		};
		conn.close() if conn;
	end
end

params = {}
for i in 0..ARGV.length do params[ARGV[i]] = ARGV[i + 1]; end
session = PostgresTest.new(params);
session.invoke();

