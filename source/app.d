import std.getopt;
import std.stdio;
import std.array;
import poi;
import writer;

void main(string[] args)
{
	string file;
	auto helpInformation = getopt(args, "from|f", "The POI file to generate a project", &file);
	
	if (helpInformation.helpWanted) {
		defaultGetoptPrinter("Project objects initializer", helpInformation.options);
	}

	if (file) {
		File(file).byLineCopy.array.parseToPOIs.writeToFiles;
	}

}
