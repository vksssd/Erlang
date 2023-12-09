FROM erlang:latest

# install rebar3 (erlang build tool)
RUN wget https://github.com/erlang/rebar3/releases/download/3.17.0/rebar3 && \
    chmod +x rebar3 && \
    mv rebar3 /usr/local/bin/

# set the working directory
WORKDIR /workspace

# copy the application code to the container
COPY . . 

# Fetch and compile the dependencies
RUN rebar3 compile

# expose the port on which erlang application will run
EXPOSE 8080

# start the erlang shell by default
CMD [ "rebar3", "shell" ]