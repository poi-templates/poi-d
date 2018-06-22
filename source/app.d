import std.getopt;
import poi;
import writer;
import loader;

void main(string[] args)
{
	string file;
	string url;
	string id;
	auto helpInformation = getopt(args, 
			"from|f", "The POI file to generate a project", &file, 
			"url|u", "The url of POI file", &url, 
			"id|i", "The POI id from central POI repo", &id);

	if (helpInformation.helpWanted)
	{
		defaultGetoptPrinter("Project objects initializer", helpInformation.options);
	}

	if (file)
	{
		content(file).parseToPOIs(poivars()).writeToFiles;
	} else if (url) {
		content(url, true).parseToPOIs(poivars()).writeToFiles;
	} else if (id) {
		content(location(id), true).parseToPOIs(poivars()).writeToFiles;
	}
}
