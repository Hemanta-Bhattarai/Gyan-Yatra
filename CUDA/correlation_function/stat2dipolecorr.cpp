#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;

int main()
{
  string data, line, word;
  int pos(8);
  vector< vector<double> > dipole_moment;
  vector<double> t;
  const string fileName = "Platinum_nanosphere_run2.stat";
  const string fileOut = "CorrfuncC++.wcorr";

  ifstream file;

  //open file

  file.open(fileName,ios::in);
  if(!file)
  {
    cout<<"Error in opening file"<<endl;
    return -1;

  }

  while(!file.eof())
  {
  //  file >> skipws >>data;
   getline(file, line);
   int i = 0;
   vector< double > dipole;
   stringstream is(line);

   while( is >> word )
   {
     if  (word.compare("#") == 0 || word.compare("##") == 0 ) break;
     if(i == 0) t.push_back(stod(word));
     if(i >= pos && i < pos + 3)
     {
       dipole.push_back(stod(word));
     }
     i++;

   }
   if (dipole.size() != 0) dipole_moment.push_back(dipole);

  }
cout<<"Dipole vector list created"<<endl;

double local_corr;

// calculation of co-orelation  function
ofstream outfile;
outfile.open(fileOut);
int length = dipole_moment.size();
double dt = t[1]-t[0];
cout<<"Finding the correlation funciton"<<endl;

outfile<<"## charge velocity autocorrelation function"<<endl;
outfile<<"# time(tau)\t wcorr"<<endl;
for(int tau= 0; tau < length ; ++tau )
{
  local_corr = 0;
  for(int i = 0; i < length - tau; ++i)
  {
    local_corr +=   (dipole_moment[i][0]*dipole_moment[i + tau][0])
                  + (dipole_moment[i][1]*dipole_moment[i + tau][1])
                  + (dipole_moment[i][2]*dipole_moment[i + tau][2]);
  }
  outfile << tau*dt << "\t" << local_corr/(length - tau)<<endl;

}
outfile.close();



}
