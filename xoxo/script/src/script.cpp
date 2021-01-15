#define LIB_NAME "ScriptExt"
#define MODULE_NAME "script"

#include <dmsdk/sdk.h>

static int GetInstance(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 1);
    dmScript::GetInstance(L);
    if (!dmScript::IsInstanceValid(L))
    {
        DM_LUA_ERROR("Script instance is not set");
    }
    return 1;
}

static int SetInstance(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, -1);
    if (!dmScript::IsInstanceValid(L))
    {
        DM_LUA_ERROR("Script instance is not valid");
    }
    dmScript::SetInstance(L);
    return 0;
}

static const luaL_reg Module_methods[] =
{
    {"get_instance", GetInstance},
    {"set_instance", SetInstance},
    {0, 0}
};

static void LuaInit(lua_State* L)
{
    int top = lua_gettop(L);
    luaL_register(L, MODULE_NAME, Module_methods);
    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result InitializeScriptExt(dmExtension::Params* params)
{
    LuaInit(params->m_L);
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(ScriptExt, LIB_NAME, 0, 0, InitializeScriptExt, 0, 0, 0)
