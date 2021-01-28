//Program to process the data detected by 7 detectors and 2 gamma ray detectors
//Hemanta Bhattarai
//Dec 1 2015
#include<iostream>
#include<string>
#include<fstream>
#include<stdlib.h>
#include<cmath>

#include "TF1.h"
#include "TFile.h"
#include "TTree.h"
#include "TH1.h"
#include "TCanvas.h"
#include "TGraph.h"
#include "TGraphErrors.h"
#include "TAxis.h"
#include "TLegend.h"
using namespace std;


int main()
{
	// histogram for various data defined
	TH1F *histo1=new TH1F("histo1","energy peaks for all gamma rays",100,125,1400);
	TH1F *histo2=new TH1F("histo2","selected energy for detector 0",1000,0,1500);
	TH1F *histo3=new TH1F("histo3","selected energy for detector 1",1000,0,1500);
	TH1F *histo4=new TH1F("histo4","selected energy for detector 2",1000,0,1500);
	TH1F *histo5=new TH1F("histo5","selected energy for detector 3",1000,0,1500);
	TH1F *histo6=new TH1F("histo6","selected energy for detector 4",1000,0,1500);
	TH1F *histo7=new TH1F("histo7","selected energy for detector 5",1000,0,1500);
	TH1F *histo8=new TH1F("histo8","selected energy for detector 6",1000,0,1500);
	TH1F *histo9=new TH1F("histo9","energy peaks",1000,0,1500);
	TH1F *histo10=new TH1F("histo10","energy peaks",1000,0,1500);
	TH1F *histo11=new TH1F("histo11","particles in 0",1000,12000,15000);
	TH1F *histo12=new TH1F("histo12","particles in 1",1000,12000,15000);
	TH1F *histo13=new TH1F("histo13","particles in 2",1000,12000,15000);
	TH1F *histo14=new TH1F("histo14","particles in 3",1000,12000,15000);
	TH1F *histo15=new TH1F("histo15","particles in 4",1000,12000,15000);
	TH1F *histo16=new TH1F("histo16","particles in 5",1000,12000,15000);
	TH1F *histo17=new TH1F("histo17","particles in 6",1000,12000,15000);
	TH1F *histo18=new TH1F("histo18","particles in 7",1000,12000,15000);


	TF1 *fx= new TF1("fx","[0]*pow(cos(x*3.12/180),2)",0,180);//fit function defined
	
	//various variable for the data defined
	Float_t a=10000.0;
	Float_t gamma_1=0;
	Float_t gamma_2=0;
	Float_t events=0;
	Float_t sum_gamma=0;
	Float_t particles[7]={0};
	Float_t angle[7]={7,22,47,67,92,127,177};
	Float_t error_y[7]={0};
	Float_t error_x[7]={2.5,2.5,2.5,2.5,2.5,2.5,2.5};
	
	Int_t detector;

	TFile *fin = TFile::Open("data.root","RECREATE");//.root file created to store the data
	TTree *t1 = new TTree("t1","detectors_tree");	//tree created
	
	//branches to store data is created
	t1->Branch("gamma_1",&gamma_1,"gamma_1/F");
	t1->Branch("gamma_2",&gamma_2,"gamma_2/F");
	t1->Branch("detector",&detector,"detector/I");
	t1->Branch("events",&events,"events/F");
	t1->Branch("sum_gamma",&sum_gamma,"sum_gamma/F");
	
	int count;
	ifstream fIn("final.dat");  // Open the .dat file which contatins the data
	if(!fIn)	
	{
		cout<<"Sorry, Unable to open file"<<endl;   //error message if file cannot be opened
		exit(0);
	}
	int kk=0;
	while(!fIn.eof())
	
	{
		
		gamma_1=0;
		gamma_2=0;
		events=0;
		sum_gamma=0;
		for(count=0;count<4;count++)
		{
			if (count==0)
			{
				
				fIn>>gamma_1;
			
				
			}
			else if (count==1)
			{
				
				fIn>>gamma_2;
				
			}
			else if (count==2)
			{
				fIn>>detector;
			
			}
			else 
    			{
				fIn>>events;
								
			}
			
			
			
		}
		sum_gamma=gamma_1+gamma_2;
		if((sum_gamma>415&&sum_gamma<450)||(sum_gamma>1335&&sum_gamma<1365)||(sum_gamma>912&&sum_gamma<942))//choosing the required spectrum
		{
					sum_gamma=0;
					
		}
	
		
		t1->Fill();
		
	}

	



	
//-------------------------------------------------------------------------------------	
	
	

	//------------------------------------------------------------------------------
	Float_t energy_particles,sum_gammaN;
	Int_t detecN;
	t1->SetBranchAddress("events",&energy_particles);
  	t1->SetBranchAddress("detector",&detecN);
	t1->SetBranchAddress("sum_gamma",&sum_gammaN);
	//filling data for the defined detectors with the number of particles encountered
	Int_t nentries = (Int_t)t1->GetEntries();
 	for (Int_t i=0; i<nentries; i++) 
	{
  		t1->GetEntry(i);
	
 		if (sum_gammaN>0)
		{
			switch(detecN)
			{
				case 0:
					histo11->Fill(energy_particles);
					histo2->Fill(sum_gammaN);
					break;
	
				case 1:
					histo12->Fill(energy_particles);
					histo3->Fill(sum_gammaN);
					break;

				case 2:
					histo13->Fill(energy_particles);
					histo4->Fill(sum_gammaN);
					break;


				case 3:
					histo14->Fill(energy_particles);
					histo5->Fill(sum_gammaN);
					break;

				case 4:
					histo15->Fill(energy_particles);
					histo6->Fill(sum_gammaN);
					break;
				case 5:
					histo16->Fill(energy_particles);
					histo7->Fill(sum_gammaN);
					break;
				case 6:
					histo17->Fill(energy_particles);
					histo8->Fill(sum_gammaN);
					break;
				


				default:
					break;
			}
			
		}
    	
  	}
	
	//Plot of the gamma ray in detectors when the different detector encounters a particle.
  	TCanvas *c2= new TCanvas("c2","histogram ",1024,1024);
	c2->Divide(2,4);
	c2->cd(1);
	histo2->Draw();
	histo2->SetStats(0);
	histo2->SetTitle("Gamma ray in D[0]");
	histo2->GetXaxis()->SetTitle("Energy");
	histo2->GetYaxis()->SetTitle("# of events");
	histo2->GetXaxis()->CenterTitle();
	histo2->GetYaxis()->CenterTitle();
	histo2->GetXaxis()->SetTitleSize(0.04);
	histo2->GetYaxis()->SetTitleSize(0.04);
	c2->cd(2);
	histo3->Draw();
	histo3->SetStats(0);
	histo3->SetTitle("Gamma ray in D[1]");
	histo3->GetXaxis()->SetTitle("Energy");
	histo3->GetYaxis()->SetTitle("# of events");
	histo3->GetXaxis()->CenterTitle();
	histo3->GetYaxis()->CenterTitle();
	histo3->GetXaxis()->SetTitleSize(0.04);
	histo3->GetYaxis()->SetTitleSize(0.04);
	c2->cd(3);
	histo2->Draw();
	histo4->SetStats(0);
	histo4->SetTitle("Gamma ray in D[2]");
	histo4->GetXaxis()->SetTitle("Energy");
	histo4->GetYaxis()->SetTitle("# of events");
	histo4->GetXaxis()->CenterTitle();
	histo4->GetYaxis()->CenterTitle();
	histo4->GetXaxis()->SetTitleSize(0.04);
	histo4->GetYaxis()->SetTitleSize(0.04);
	c2->cd(4);
	histo5->Draw();
	histo5->SetStats(0);
	histo5->SetTitle("Gamma ray in D[3]");
	histo5->GetXaxis()->SetTitle("Energy");
	histo5->GetYaxis()->SetTitle("# of events");
	histo5->GetXaxis()->CenterTitle();
	histo5->GetYaxis()->CenterTitle();
	histo5->GetXaxis()->SetTitleSize(0.04);
	histo5->GetYaxis()->SetTitleSize(0.04);
	c2->cd(5);
	histo6->Draw();
	histo6->SetStats(0);
	histo6->SetTitle("Gamma ray in D[4]");
	histo6->GetXaxis()->SetTitle("Energy");
	histo6->GetYaxis()->SetTitle("# of events");
	histo6->GetXaxis()->CenterTitle();
	histo6->GetYaxis()->CenterTitle();
	histo6->GetXaxis()->SetTitleSize(0.04);
	histo6->GetYaxis()->SetTitleSize(0.04);
	c2->cd(6);
	histo7->Draw();
	histo7->SetStats(0);
	histo7->SetTitle("Gamma ray in D[5]");
	histo7->GetXaxis()->SetTitle("Energy");
	histo7->GetYaxis()->SetTitle("# of events");
	histo7->GetXaxis()->CenterTitle();
	histo7->GetYaxis()->CenterTitle();
	histo7->GetXaxis()->SetTitleSize(0.04);
	histo7->GetYaxis()->SetTitleSize(0.04);
	c2->cd(7);
	histo8->Draw();
	histo8->SetStats(0);
	histo8->SetTitle("Gamma ray in D[6]");
	histo8->GetXaxis()->SetTitle("Energy");
	histo8->GetYaxis()->SetTitle("# of events");
	histo8->GetXaxis()->CenterTitle();
	histo8->GetYaxis()->CenterTitle();
	histo8->GetXaxis()->SetTitleSize(0.04);
	histo8->GetYaxis()->SetTitleSize(0.04);
		
	
	
	c2->SaveAs("Bhattarai_Histo_detectors.pdf");
	c2->Close();

	//Drawing histogram for the partilces in different detectors.
	TCanvas *c3= new TCanvas("c3","histogram ",800,800);
	c3->Divide(2,4);
	c3->cd(1);
	
	particles[0]=histo11->Integral();
	histo11->Draw();
	histo11->SetStats(0);
	histo11->SetTitle("Particles in D[0]");
	histo11->GetXaxis()->SetTitle("Energy of particles");
	histo11->GetYaxis()->SetTitle("# of events");
	histo11->GetXaxis()->CenterTitle();
	histo11->GetYaxis()->CenterTitle();
	histo11->GetXaxis()->SetTitleSize(0.04);
	histo11->GetYaxis()->SetTitleSize(0.04);
	

	c3->cd(2);
	
	particles[1]=histo12->Integral();
	histo12->Draw();
	histo12->SetStats(0);
	histo12->SetTitle("Particles in D[1]");
	histo12->GetXaxis()->SetTitle("Energy of particles");
	histo12->GetYaxis()->SetTitle("# of events");
	histo12->GetXaxis()->CenterTitle();
	histo12->GetYaxis()->CenterTitle();
	histo12->GetXaxis()->SetTitleSize(0.04);
	histo12->GetYaxis()->SetTitleSize(0.04);
	
	
	c3->cd(3);
	
	particles[2]=histo13->Integral();
	histo13->Draw();
	histo13->SetStats(0);
	histo13->SetTitle("Particles in D[2]");
	histo13->GetXaxis()->SetTitle("Energy of particles");
	histo13->GetYaxis()->SetTitle("# of events");
	histo13->GetXaxis()->CenterTitle();
	histo13->GetYaxis()->CenterTitle();
	histo13->GetXaxis()->SetTitleSize(0.04);
	histo13->GetYaxis()->SetTitleSize(0.04);
	
	c3->cd(4);
	
	particles[3]=histo14->Integral();
	histo14->Draw();
	histo14->SetStats(0);
	histo14->SetTitle("Particles in D[3]");
	histo14->GetXaxis()->SetTitle("Energy of particles");
	histo14->GetYaxis()->SetTitle("# of events");
	histo14->GetXaxis()->CenterTitle();
	histo14->GetYaxis()->CenterTitle();
	histo14->GetXaxis()->SetTitleSize(0.04);
	histo14->GetYaxis()->SetTitleSize(0.04);
	
	
	c3->cd(5);
	
	particles[4]=histo15->Integral();
	histo15->Draw();
	histo15->SetStats(0);
	histo15->SetTitle("Particles in D[4]");
	histo15->GetXaxis()->SetTitle("Energy of particles");
	histo15->GetYaxis()->SetTitle("# of events");
	histo15->GetXaxis()->CenterTitle();
	histo15->GetYaxis()->CenterTitle();
	histo15->GetXaxis()->SetTitleSize(0.04);
	histo15->GetYaxis()->SetTitleSize(0.04);
	

	c3->cd(6);
	particles[5]=histo16->Integral();
	histo16->Draw();
	histo16->SetStats(0);
	histo16->SetTitle("Particles in D[5]");
	histo16->GetXaxis()->SetTitle("Energy of particles");
	histo16->GetYaxis()->SetTitle("# of events");
	histo16->GetXaxis()->CenterTitle();
	histo16->GetYaxis()->CenterTitle();
	histo16->GetXaxis()->SetTitleSize(0.04);
	histo16->GetYaxis()->SetTitleSize(0.04);
	
	

	c3->cd(7);
	particles[6]=histo17->Integral();
	histo17->Draw();
	histo17->SetStats(0);
	histo17->SetTitle("Particles in D[6]");
	histo17->GetXaxis()->SetTitle("Energy of particles");
	histo17->GetYaxis()->SetTitle("# of events");
	histo17->GetXaxis()->CenterTitle();
	histo17->GetYaxis()->CenterTitle();
	histo17->GetXaxis()->SetTitleSize(0.04);
	histo17->GetYaxis()->SetTitleSize(0.04);
	
	

	c3->SaveAs("Bhattarai_histo_particles.pdf");
	c3->Close();
	for(int ii=0;ii<7;ii++)
	{
		error_y[ii]=sqrt(particles[ii]);	
	}
	
//---------------------------------------------------------------------------------------------
	//Drawing fit of the function to find the appropriate distribution function
	TCanvas *c4= new TCanvas("c4","histogram ",600,600);
	c4->cd(1);	
	TGraphErrors *gr=new TGraphErrors(7,angle,particles,error_x,error_y);
	gr->SetMarkerStyle(21);
	gr->SetTitle("Angular Distribution Function f(#theta)");
	gr->Draw("ap");
	gr->Fit("fx","R");
	gr->GetXaxis()->SetTitle("#theta");
	gr->GetYaxis()->SetTitle("events");
	gr->GetXaxis()->CenterTitle();
	gr->GetYaxis()->CenterTitle();
	gr->GetYaxis()->SetTitleOffset(1.5);

	Double_t par=fx->GetParameter(0);
	cout<<par<<endl;
	fx->SetParameter(0,par);
	fx->SetLineColor(kRed);
	fx->SetLineWidth(1);

	fx->Draw("same");

	TLegend *leg = new TLegend(0.7,0.2,.9,.3);
	leg->AddEntry("fx","fit of f(#theta)","l");
	leg->AddEntry("gr","Exp. Data","lep");
	leg->Draw();
	
	c4->SaveAs("Bhattarai_fit.pdf");
	c4->Close();
	
	
	
	fin->Write();
	fin->Close();	
return(0);
	
}
