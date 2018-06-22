import mustache;
import std.json;
import std.conv : to;

alias Mustache = MustacheEngine!string;
alias Context = Mustache.Context;

private Mustache mustacheRender;

/// append new json content to Context ctx
Context parseToContext(string jsonText, Context ctx)
{

    JSONValue j = parseJSON(jsonText);
    ctx = appendJsonValue(j, ctx);
    return ctx;
}

private Context appendJsonValue(JSONValue j, Context ctx)
{
    foreach (string k, v; j)
    {
        if (v.type != JSON_TYPE.OBJECT)
        {
            ctx[k] = jsonValueToString(v);
        }
        else
        {
            auto sub = ctx.addSubContext(k);
            sub = appendJsonValue(v, sub);
        }
    }
    return ctx;
}

unittest
{

    auto context = new Context;
    auto ctx = parseToContext(`
        {
            "name": "Kimmy",
            "age": 25,
            "married": false,
            "height": 173.7
        }
    `, context);

    assert(ctx["name"] == "Kimmy");
    assert(ctx["age"] == "25");
    assert(ctx["married"] == "false");
    assert(ctx["height"] == "173.7");
}

private string jsonValueToString(JSONValue value)
{
    switch (value.type())
    {
    case JSON_TYPE.STRING:
        return value.str;
    case JSON_TYPE.FLOAT:
        return to!string(value.floating);
    case JSON_TYPE.INTEGER:
        return to!string(value.integer);
    case JSON_TYPE.FALSE:
        return to!string(false);
    case JSON_TYPE.TRUE:
        return to!string(true);
    case JSON_TYPE.UINTEGER:
        return to!string(value.uinteger);
    default:
        return "";
    }
}

unittest
{
    /// valid case
    assert(jsonValueToString(JSONValue("hello")) == "hello");
    assert(jsonValueToString(JSONValue(1)) == "1");
    assert(jsonValueToString(JSONValue(true)) == "true");
    assert(jsonValueToString(JSONValue(false)) == "false");
    assert(jsonValueToString(JSONValue(1.5)) == "1.5");
    assert(jsonValueToString(JSONValue(123u)) == "123");

    /// invalid case
    assert(jsonValueToString(JSONValue(["abc" : 1])) == "");
}

/// render the source with provided context
string renderContext(string source, Context context)
{
    return mustacheRender.renderString(source, context);
}

/// render the source with provided JSON text
string renderString(string source, string jsonText)
{
    return renderContext(source, parseToContext(jsonText, new Context));
}

unittest
{
    immutable result = renderString("{{name}}, {{age}}, {{married}}", `
        {
            "name": "Kimmy",
            "age": 25,
            "married": false,
            "height": 173.7
        }
    `);

    assert(result == "Kimmy, 25, false");

    immutable resultWithNestedContext = renderString("{{project.name}}", `
        {
            "project": {
                "name": "POI"
            }
        }
    `);

    assert(resultWithNestedContext == "POI");
}
