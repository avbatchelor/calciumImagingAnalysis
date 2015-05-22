%% Image processing test 

filename = ('C:\Users\Alex\Documents\Data\CalciumImagingData\B1\150521\150521_F4_C1\SpeakerChirp_Raw_150521_F4_C1_114');
data = load(filename);
scimStackROI(data,data.params,'MakeMovie',true);

map = colormap(gray);
move = immovie(I0(:,:,:,2),map);
implay(mov)