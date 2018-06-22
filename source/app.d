import std.getopt;
import std.stdio;
import std.file;
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
		string poivars = "{}";
		if (exists(".poi_vars")) {
			poivars = readText(".poi_vars");
		}
		File(file).byLineCopy.array.parseToPOIs(poivars).writeToFiles;
	}

}
