APP ?= scgi_app
CLIBS ?= scgilib.c mmap_util.c
CHDRS ?= scgilib.h mmap_util.h

$(APP): $(APP).c $(CLIBS) $(CHDRS)
	gcc -O3 -lhiredis  -o $@  $< $(CLIBS)

.PHONY: run resetdb kill-redis kill-nginx shutdown clean

run: $(APP) nginx.pid redis.pid
	pkill -x $(APP) || true
	./$(APP)

nginx.pid: nginx.conf logs/error.log
	test -f nginx.pid && kill -HUP $(shell cat nginx.pid 2>/dev/null) || nginx -p $(CURDIR) -c $<

logs/error.log:
	mkdir logs
	touch logs/error.log

shutdown: kill-nginx kill-redis

kill-nginx:
	test -f nginx.pid && kill $(shell cat nginx.pid 2>/dev/null) || true

redis.pid: redis.conf
	test -f redis.pid && kill $(shell cat redis.pid 2>/dev/null) || true
	redis-server $^

kill-redis:
	test -f redis.pid && kill $(shell cat redis.pid 2>/dev/null) || true

resetdb: kill-redis
	test -f redis.rdb && rm -i redis.rdb || true

clean: shutdown resetdb
	rm -f $(APP)
	rm -rf *.log logs/
