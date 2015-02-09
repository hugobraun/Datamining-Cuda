#include <iostream>
#include <fstream>

#include <sstream>
#include "dataLoader.h"


using namespace std;

#define DIM 166
#define N 5622

int main() {
	int * data = new int[DIM*N];
	int * cdata = new int[N];

	loadData("data.csv", cdata, data);


	return 0;

}

void loadData(string filename, int * cdata, int * data) {
	ifstream file;
	string line;
	string cell;

	file.open (filename.c_str());
		int i = 0;

		if (file.is_open()) {
			while (getline (file,line) ) {
			int j = 0;
			stringstream  lineStream(line);
			getline(lineStream,cell,',');
			int c = atoi(cell.c_str());
			cdata[i] = c;

			while(getline(lineStream,cell,',')) {
				int d = atoi(cell.c_str());
				data[DIM * i + j] = d;
				j++;
			}

			i++;
			}
			file.close();
		}
}
