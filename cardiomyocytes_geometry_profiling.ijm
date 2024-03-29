
// ===============================
// AUTHOR : Gisele Miranda
// IVESTIGATORS : Zaher Elbeck, Christer Betsholtz
// CREATE DATE : 2021 - 05 - 12
// PURPOSE : Cell's geometry profiling for neonatal rat cardiomyocytes in 2D culture
// NOTES : Fiji required - https://fiji.sc, 
// ===============================


/************* parameters *************/
thresholdMethod = "Li"; // threshold method
minCellArea = 50000; // minimum area of a cell - used to filter small particles or partially detected cells
/**************************************/

// define the path of the input directory, e.g., C:/Users/images/input/. This directory should contain subfolders corresponding to the different experimental conditions
path = "";
// define the names of the input folders corresponding to the different experimental groups
folders = newArray("Control","NAC","SF");
// buffer of measures to be saved in an output csv file
bufferMeasures = "Group;File name;Total Area\n";

// for all input folders
for(count=0; count<folders.length; count++) {
	files = getFileList(path + folders[count]);

	// create output path - nomenclature is a combination of the input parameters
	outPath = path + folders[count] + "/overlay_thr-" + thresholdMethod + "_minCellArea-" + minCellArea + "/";
    File.makeDirectory(outPath);

	// iterate over all images of the selected folder
	for(countFile=0; countFile<files.length; countFile++) {
		file = files[countFile];

		if(!startsWith(file, "overlay")) { // ignore overlay folder, which is created to store results
			
			// process different input formats of the image files
			if(matches(folders[count],"Control") || matches(folders[count], "NAC1"))
				run("Bio-Formats Importer", "open=[" + path + folders[count] + "/" + file + "] color_mode=Default view=Hyperstack stack_order=XYZCT");
			else
				open(path + folders[count] + "/" + file);
			rename("image");
			
			run("Stack to Images");
			selectWindow("image-0002");
			close();
			
			// process cardiomyocites channel
			selectWindow("image-0001");
			run("Set Scale...", "distance=0 known=0 unit=pixel");
			run("Grays");
			run("Duplicate...", "image-0001_mask");
			rename("image-0001_mask");
			run("Enhance Contrast", "saturated=0.35");
			run("Apply LUT");
			run("Median...", "radius=4");
			setAutoThreshold(thresholdMethod + " dark");
			setOption("BlackBackground", true);
			run("Convert to Mask");
			run("Fill Holes");
	
			// extract total area from mask and related measures
			run("Set Measurements...", "area centroid perimeter shape feret's redirect=None decimal=2");
			run("Analyze Particles...", "size=" + minCellArea + "-Infinity show=Masks exclude clear summarize add");
			roiManager("Show None");
			
			Table.rename("Summary", "Results");
			tot_area = getResult("Total Area", 0);
			selectWindow("Results"); 
			run("Close");

			// extract shape descriptors
			roiManager("Measure");
			saveAs("Results", outPath + "results_" + file + ".csv");

			selectWindow("image-0001");
			run("From ROI Manager");
			saveAs("Tiff", outPath + "carciomyocytes_" + file);

			selectWindow("Results"); 
			run("Close");
			selectWindow("ROI Manager"); 
			run("Close");

			run("Close All");

			// save measures to buffer
			bufferMeasures = bufferMeasures + folders[count] + ";" + file + ";" + tot_area + "\n";
		}
	}
}

// save buffer to csv file
summaryPath = path + "summaryMeasures_thr-" + thresholdMethod + "_minCellArea-" + minCellArea + ".csv";
if(File.exists(summaryPath))
	File.delete(summaryPath);

summaryFile = File.open(summaryPath);
print(summaryFile, bufferMeasures);
File.close(summaryFile);
