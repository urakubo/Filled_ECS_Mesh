classdef ParamClass<handle

    properties
		%%
		%%
		%%
		AnnotaionMultiTiffFileName = '.\DATA\MultiTiff.tif';
		xp = 9.780; %% nm
		yp = 7.708; %% nm
		zp = 40;    %% nm
		Radius = 2;
		% az = -24;
		% el = 66;
		az = -20;
		el = 30;

		%%
		%% Mesh parameters
		%%

		maxvol = 100;
		opt = struct( ...
			'radbound' , 5, ...    % Max tetrahedra size
			'distbound', 1,...      % Distance from surface structure to volume mesh
			'maxnode', 400000 ...
			); 
    end
end

