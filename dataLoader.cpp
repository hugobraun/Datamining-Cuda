#include <iostream>
#include <fstream>

#include <sstream>
#include "dataLoader.h"

#include "configuration.h"

#import "CPU/cpu_knn.h"

using namespace std;


int main() {
	int * data = new int[DIM*N];
	int * cdata = new int[N];

	loadData("data.csv", cdata, data);

	int ipoint = 5;
	int * point = new int[DIM];

	for(int i = 0; i < DIM; i++)
		point[i] = data[ipoint * DIM + i];



	cout << "kNN class : " << cpu_knn(cdata, data, point, 2) << " expected : " << cdata[5];

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
