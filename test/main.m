#import <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <lua/lua.h>
#include <lua/lauxlib.h>
#include <lua/lualib.h>

static void handle_signal(int sig) {
    CFRunLoopStop(CFRunLoopGetMain());
}

int main(int argc, const char * argv[]) {
    if (argc < 2) {
        printf("usage: %s <lua file>\n", argv[0]);
        return 0;
    }
    lua_State* l = luaL_newstate();
    luaL_openlibs(l);
    const char* fpath = argv[1];
    if (luaL_dofile(l, fpath)) {
        fprintf(stderr, "run lua file %s failed: %s\n", fpath, lua_tostring(l, -1));
        return 0;
    }
    signal(SIGTERM, handle_signal);
    signal(SIGINT, handle_signal);
    CFRunLoopRun();
    lua_close(l);
    return 0;
}

