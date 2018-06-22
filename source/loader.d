import std.file : remove, write, exists, readText;
import std.array : array;
import std.net.curl : byLine;
import std.algorithm : map, startsWith;
import std.stdio : File, writeln;
import std.format;

/// retrieve poi file content
string[] content(string file, bool isUrl = false)
{
    if (isUrl || file.startsWith("http"))
        return byLine(file).map!(i => i.idup).array;
    return File(file).byLineCopy.array;
}

unittest
{
    content(location("ruby/gem/init"));
}

/// retrieve poivars configurations
string poivars()
{
    if (exists(".poi_vars"))
        return readText(".poi_vars");
    return "{}";
}

unittest
{
    assert(poivars() == "{}");

    write(".poi_vars", "some text");
    assert(poivars == "some text");

    ".poi_vars".remove;
}

/// generate central POI repo url
string location(string id) {
    return format!("https://raw.githubusercontent.com/poi-templates/pois/master/%s.poi")(id);
}
