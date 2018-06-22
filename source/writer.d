import poi;

import std.file;

import std.path;

import std.array : split;

/// write pois result to files
void writeToFiles(POIs pois)
{
    auto context = pois.context;

    foreach (string k, poi; pois.pois)
    {
        writeToFile(k, poi.render(context));
    }
}

private void writeToFile(string fileName, string content)
{
    if (!exists(dirName(fileName))) {
        mkdirRecurse(dirName(fileName));
    }
    write(fileName, content);
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
    auto pois = parseToPOIs(source.split("\n"));
    writeToFiles(pois);


    assert (pois.context()["message"] == "hello world");

    assert (exists(".poi_defaults"));
    assert (exists("abc/def/123.txt"));
    assert (exists("hello.c"));

    "hello.c".remove;
    "abc".rmdirRecurse;
    ".poi_defaults".remove;
}
