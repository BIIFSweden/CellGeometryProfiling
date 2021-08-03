# Cell's geometry profiling for neonatal rat cardiomyocytes in 2D culture

The pipeline provided in this project performs cell segmentation and quantification using Fiji and it was implemented in ImageJ Macro Language.

#### 1.	Input directory

The input directory should contain subfolders corresponding to the different experimental conditions. For the images of neonatal rat cardiomyocytes, there are three experimental groups: Control, NAC and SF

#### 2.	Software requirements

The software listed below should be installed before running the Fiji script. 

* [Fiji](https://fiji.sc): follow the instructions in the link to download Fiji.
* [Bioformats plugin](https://imagej.net/Bio-Formats). See section “Daily builds” in order to check if bioformats plugin is installed/updated.

#### 3.	Running the pipeline

To run the pipeline, open Fiji and go to Plugins – Macros – Edit... and browse the *cardiomyocytes_geometry_profiling.ijm* file to load the script. Two parameters can be modified in the pipeline: 

* thresholdMethod: selected threshold method. Default is set to Li’s Minimum Cross Entropy
* minCellArea: minimum area in pixels of a particle to be considered in the analysis

After adjusting the parameters, press the “Run” button and wait until all images are processed. During the execution of the pipeline, the “Run” button will be disabled.


#### 4.	Ouput files

* A summary file (*csv format*) saved in the input directory containing the total cell area for each processed file.
* Files containing the measurements of each segmented particle and for each processed file.
*	A folder named “output” containing the segmentation results for each processed file, as illustrated below.

Note: the nomenclature of the output folders and files contains a combination of the selected parameter values. 



