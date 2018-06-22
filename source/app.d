import std.stdio;
import render;

import std.getopt;

void main(string[] args)
{
	string file;
	auto helpInformation = getopt(args, "from|f", "The POI file to generate a project", &file);
	
	if (helpInformation.helpWanted) {
		defaultGetoptPrinter("Project objects initializer", helpInformation.options);
	}

}
