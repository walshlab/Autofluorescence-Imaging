%% IMPORT INSTRUCTIONS 

% Go to the home tab and click import. Import the correct sheet and then
% import as string array

%% Collecting data from made spreadsheet

% Indicates the column of the masked data from CellProfiler 
imageMaskList=NEWMaskInformation(:,1);

% NADH & FAD a1, t1, t2, and photon files from SPCImage
NADHa1ImageList=NEWMaskInformation(:,2); 
NADHt1ImageList=NEWMaskInformation(:,3); 
NADHt2ImageList=NEWMaskInformation(:,4); 
NADHIntensityImageList=NEWMaskInformation(:,5); 
FADa1ImageList=NEWMaskInformation(:,6); 
FADt1ImageList=NEWMaskInformation(:,7); 
FADt2ImageList=NEWMaskInformation(:,8); 
FADIntensityImageList=NEWMaskInformation(:,9); 

% Describes the number of masked images we will be analyzing 
ImageNumber=21;

%Creating empty array for multiple file types 
FINALNADHIntensityList = [];
FINALNADHa1List = [];
FINALNADHt1List = [];
FINALNADHt2List = [];
FINALNADHFLIMList = [];

FINALFADIntensityList = [];
FINALFADa1List = [];
FINALFADt1List = []; 
FINALFADt2List = [];
FINALFADFLIMList = [];

FINALredoxRatioList = [];
FINALFLIRRList = [];

%% Calculate FLIM features (a1,t1,t2, intensity) 
for l = 1:ImageNumber        
        % Read the endpoint of each image
        
        % NOTE: This part is grabbing the numeric values from the table
        % listed above. Notice it will have a value for each pixel from the
        % image when listed. 
        
        NADHa1Image = dlmread(char(NADHa1ImageList(l,1)));
        NADHt1Image = dlmread(char(NADHt1ImageList(l,1)));
        NADHt2Image = dlmread(char(NADHt2ImageList(l,1)));
        NADHIntensityImage = dlmread(char(NADHIntensityImageList(l,1)));

        FADa1Image = dlmread(char(FADa1ImageList(l,1)));
        FADt1Image = dlmread(char(FADt1ImageList(l,1)));
        FADt2Image = dlmread(char(FADt2ImageList(l,1)));
        FADIntensityImage = dlmread(char(FADIntensityImageList(l,1)));

       % Grab the picture of the image mask based off CellProfiler data
       imageMask = imread(char(imageMaskList(l,1)));
       
       % Following step grabs the unique values from array 
       % Collecting color differentiation between each identified cell
       cellNumber =  unique(imageMask); 
       [cellNumber,~] = size(cellNumber);
        
        % Generate endpoint list to save the result
        NADHIntensityList = zeros(cellNumber-1,1);
        NADHa1List = zeros(cellNumber-1,1);
        NADHt1List = zeros(cellNumber-1,1);
        NADHt2List = zeros(cellNumber-1,1);
        NADHFLIMList = zeros(cellNumber-1,1);

        FADIntensityList = zeros(cellNumber-1,1);
        FADa1List = zeros(cellNumber-1,1);
        FADt1List = zeros(cellNumber-1,1);
        FADt2List = zeros(cellNumber-1,1);
        FADFLIMList = zeros(cellNumber-1,1);

        redoxRatioList = zeros(cellNumber-1,1);
        FLIRRList = zeros(cellNumber-1,1);
        %% Calculate the endpoint of each cell
        for i = 1: cellNumber-1

            imageMaskCopy = double(imageMask);            
            imageMaskCopy(imageMaskCopy~=i) = 0;
            imageMaskCopy = imageMaskCopy/i;
            
            cellNADHa1Image = NADHa1Image/100 .* imageMaskCopy;
            cellFADa1Image = FADa1Image/100 .* imageMaskCopy;
            
            cellFADa1Image(cellFADa1Image < 0.3)= 0;
            cellFADa1Image(cellFADa1Image > 1) = 0;
            cellNADHa1Image(cellNADHa1Image <0.3)=0;
            cellNADHa1Image(cellNADHa1Image > 1) = 0;
            imageMaskOne = cellFADa1Image;
            imageMaskOne(imageMaskOne>0) = 1;
            imageMaskTwo = cellNADHa1Image;
            imageMaskTwo(imageMaskTwo>0) = 1;
            imageMaskCopy = imageMaskOne.*imageMaskTwo;
            
            % Calculate FLIM endpoints
            cellNADHIntensityImage = NADHIntensityImage .* imageMaskCopy;
            cellNADHa1Image = NADHa1Image/100 .* imageMaskCopy;
            cellNADHt1Image = NADHt1Image .* imageMaskCopy;
            cellNADHt2Image = NADHt2Image .* imageMaskCopy;
            cellNADHFLIMImage = cellNADHa1Image.* cellNADHt1Image + (1 - cellNADHa1Image).* cellNADHt2Image;

            cellFADIntensityImage = FADIntensityImage .* imageMaskCopy;
            cellFADa1Image = FADa1Image/100 .* imageMaskCopy;
            cellFADt1Image = FADt1Image .* imageMaskCopy;
            cellFADt2Image = FADt2Image .* imageMaskCopy;
            cellFADFLIMImage = cellFADa1Image.* cellFADt1Image + (1 - cellFADa1Image).* cellFADt2Image;

            cellRedoxRatioImage = cellFADIntensityImage./(cellFADIntensityImage + cellNADHIntensityImage );
            cellFLIRRImage = (1 - cellNADHa1Image)./cellFADa1Image;
            cellFLIRRImage(isinf(cellFLIRRImage)) = NaN;
            %%
            cellNADHIntensity = nanmean(nonzeros(cellNADHIntensityImage));
            cellNADHa1 = nanmean(nonzeros(cellNADHa1Image));
            cellNADHt1 = nanmean(nonzeros(cellNADHt1Image));
            cellNADHt2 = nanmean(nonzeros(cellNADHt2Image));
            cellNADHFLIM = nanmean(nonzeros(cellNADHFLIMImage));

            cellFADIntensity = nanmean(nonzeros(cellFADIntensityImage));
            cellFADa1 = nanmean(nonzeros(cellFADa1Image));
            cellFADt1 = nanmean(nonzeros(cellFADt1Image));
            cellFADt2 = nanmean(nonzeros(cellFADt2Image));
            cellFADFLIM = nanmean(nonzeros(cellFADFLIMImage));

            cellRedoxRatio = nanmean(nonzeros(cellRedoxRatioImage));
            cellFLIRR = nanmean(nonzeros(cellFLIRRImage));

            %% Save features to the list
            if(isnan(cellNADHIntensity)||isnan(cellNADHa1)||isnan(cellNADHt1)||isnan(cellNADHt2)||isnan(cellNADHFLIM)||...
                    isnan(cellFADIntensity)||isnan(cellFADa1)||isnan(cellFADt1)||isnan(cellFADt2)||isnan(cellFADFLIM)||...
                    isnan(cellRedoxRatio)||isnan(cellFLIRR))

                FINALNADHIntensityList1(i,l) = NaN;
                FINALNADHa1List(i,l) = NaN;
                FINALNADHt1List(i,l) = NaN;
                FINALNADHt2List(i,l) = NaN;
                FINALNADHFLIMList(i,l) = NaN;

                FINALFADIntensityList(i,l) = NaN;
                FINALFADa1List(i,l) = NaN;
                FINALFADt1List(i,l) = NaN;
                FINALFADt2List(i,l) = NaN;
                FINALFADFLIMList(i,l) = NaN;

                FINALredoxRatioList(i,l) = NaN;
                FINALFLIRRList(i,l) = NaN;

            else
                FINALNADHIntensityList(i,l) = cellNADHIntensity;
                FINALNADHa1List(i,l) = cellNADHa1;
                FINALNADHt1List(i,l) = cellNADHt1;
                FINALNADHt2List(i,l) = cellNADHt2;
                FINALNADHFLIMList(i,l) = cellNADHFLIM;

                FINALFADIntensityList(i,l) = cellFADIntensity;
                FINALFADa1List(i,l) = cellFADa1;
                FINALFADt1List(i,l) = cellFADt1;
                FINALFADt2List(i,l) = cellFADt2;
                FINALFADFLIMList(i,l) = cellFADFLIM;

                FINALredoxRatioList(i,l) = cellRedoxRatio;
                FINALFLIRRList(i,l) = cellFLIRR;
            end   
        end
end