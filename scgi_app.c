#include "scgilib.h"
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <hiredis/hiredis.h>

#define PORT 8000
#define MAX_CONNS 5

int main(void)
{
  if(!scgi_initialize(PORT)) exit(1);
  redisContext* c=redisConnectUnix("redis.sock");
  while(1) {
    usleep(100000);
    int connections = 0;
    scgi_request *req;
    while((req=scgi_recv()) && connections++ < MAX_CONNS) {
      uint64_t count = ((redisReply*)redisCommand(c,"INCR counter"))->integer;
      char* resp;
      asprintf(&resp,"HTTP/1.1 200 OK\r\n"
                     "\r\n"
                     "Oh, hi! You are visitor number %llu.\r\n"
          ,count);
      scgi_write(req, resp);
      free(resp);
    }
  }
}
