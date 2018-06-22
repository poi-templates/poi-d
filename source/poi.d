import render;
import std.conv : to;
import std.regex;
import std.array : join, split;
import std.file : exists, readText;

/// simple file in POI
struct POI
{

    /// POI content
    string[] content;

    private this(string[] content)
    {
        this.content = content;
    }

    /// render with context
    string render(Context ctx)
    {
        return renderContext(content.join("\n"), ctx);
    }
}

/// packed files in POI
struct POIs
{

    /// POI information
    POI[string] pois;

    /// variable configuration
    string poivars = "{}";

    /// predefined variables
    string poidefaults = "{}";

    /// get combined context of pois
    Context context()
    {
        auto ctx = new Context;

        ctx = parseToContext(poidefaults, ctx);
        return parseToContext(poivars, ctx);
    }
}

private const auto REGEX_FILENAME = regex(r"^(.*)\s+(\d+)$");

unittest
{
    const res = matchFirst("hello.c 11", REGEX_FILENAME);

    assert(res);
    assert(res[1] == "hello.c");
    assert(res[2] == "11");

    const res2 = "some other text".matchFirst(REGEX_FILENAME);

    assert(!res2);
}

/// parse poi file into POI structure
POIs parseToPOIs(string[] text, string poivars = "{}")
{
    POIs p;

    p.poivars = poivars;

    for (int i; i < text.length; i++)
    {
        auto match = matchFirst(text[i], REGEX_FILENAME);

        assert(match || text[i] == ".");

        if (match)
        {
            auto filename = match[1];
            auto count = to!uint(match[2]);
            auto content = text[i + 1 .. i + 1 + count];
            p.pois[filename] = POI(content);
            i += (count + 1); // +1 to skip the empty line
            if (filename == ".poi_defaults")
            {
                p.poidefaults = content.join("\n");
            }
        }
    }

    return p;
}

unittest
{
    auto source = `.poi_defaults 3
{
    "message": "hello world"
}

abc/def/123.txt 3
abc
def
123

hello.c 5
#include <stdio.h>

int main() {
    return printf("{{message}}");
}

.`;

    auto p = parseToPOIs(source.split("\n"));

    assert(p.pois.length == 3);
    assert(p.pois["abc/def/123.txt"].content.length == 3);
    assert(p.pois["hello.c"].content.length == 5);
    assert(p.pois[".poi_defaults"].content.length == 3);

    auto p2 = parseToPOIs(source.split("\n"), `{"message": "bye world"}`);
    assert(p2.context["message"] == "bye world");
}
