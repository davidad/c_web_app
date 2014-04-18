Interviewer: "What language are you most comfortable with?"<br>
davidad: "C."<br>
Interviewer: "Oh. We usually have people make a web app, so..."<br>
davidad: "No problem. I'm prepared for this."

## c_web_app

### Requirements

* `nginx`: I follow [these instructions](https://github.com/davidad/openresty-heroku-example/blob/master/Building_OpenResty_locally.md) to get a local build of `nginx` available
* `redis`: usually `[package-manager] install redis`
* `hiredis`: usually `[package-manager] install hiredis`; make sure that the libs are actually available (I did `sudo ln -sf /usr/local/opt/hiredis/lib/* /usr/lib` and `sudo ln -sf /usr/local/opt/hiredis/include/* /usr/include`)

###Makefile targets

    $ make run          # runs the app, compiling it and spinning up redis and nginx if necessary
    $ make nginx.pid    # spins up nginx
    $ make redis.pid    # spins up redis
    $ make kill-nginx   # shuts down nginx
    $ make kill-redis   # shuts down redis
    $ make resetdb      # deletes the redis.rdb database, shutting down redis first if necessary
    $ make clean        # shut down everything, remove binary and log files. run before `git commit`
