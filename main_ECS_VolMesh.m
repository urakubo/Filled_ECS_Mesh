%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mod by H Urakubo                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%%%
%%%
function  main_OneObjectRev

%% Init, Path, & Parameters
	clear;
	Addpaths();
	p = ParamClass;

%% Load Multipage Tiff File for Annotaion
	IM = LoadMultiPageTiff(p.AnnotaionMultiTiffFileName);
	SegNUM = max(max(max(IM)));
	COLNUM   = SegNUM+1;
	col = colormap(colorcube(COLNUM));

%% Remap it to equally-spaced matrix
	IM2 = RemapVolImage(IM, p);
	[xn, yn, zn] = size(IM2);
	XX = (1:xn)*p.xp;
	YY = (1:yn)*p.xp;
	ZZ = (1:zn)*p.xp;

%% Target & smoothing

	InsideOut = ones(size(IM2),'logical');
	TNUM = [1:SegNUM];
%	TNUM = [1:40];

	for i = 1:numel(TNUM);
		IMt = (IM2 == TNUM(i));
		IMt = Smoothing(IMt, p.Radius);
		InsideOut = InsideOut - IMt;
		fprintf('%g ',i);
	end;

	save('InsideOut_VolData170924.mat','InsideOut');

	[node, elem ,regions, holes]=v2s(InsideOut,0.5,p.opt,'cgalsurf');
	save('InsideOut_SurfMesh170924.mat','node','elem','regions','holes');
	
	InsideOut = uint8(InsideOut);
	[node,elem,face]=v2m(InsideOut,0.5,p.opt,p.maxvol,'cgalmesh');
	save('InsideOut_VolMesh170924.mat','node','elem','face');
	FILENAME = sprintf('./TestAbaqus.inp');
    saveabaqus_mod2(node,face,elem,FILENAME);
    
	% limitations
	% 1) only accept uint8 volume
	% 2) can not extract meshes from gray-scale volumes.
	
	
%%%
%%% Plot and save
%%%

	figure;
	plotmesh(node,elem); 
	xlabel('(\mum)');
	ylabel('(\mum)');
	zlabel('(\mum)');
	view(p.az,p.el);
	saveas(gca, 'ECS.png');% Dendrite Axon Glia UnID

	

%%%
%%%
%%% Subroutines
%%%
%%%

%%%
%%% Plot a target spine
%%%


function Addpaths()

	addpath('..\Matlab');
	addpath('..\Matlab\iso2mesh');
 	addpath('..\Matlab\STLRead');
 	addpath('..\Matlab\FastMarching_version3b');
	addpath('..\Matlab\FastMarching_version3b\functions');
	addpath('..\Matlab\FastMarching_version3b\shortestpath');
	addpath('..\Matlab\distancePointLine');


function IM = LoadMultiPageTiff(MultiTiffFileName);
	info = imfinfo(MultiTiffFileName);
	xnum  = info(1).Width;
	ynum  = info(1).Height;
	znum  = numel(info);
	IM    = zeros(xnum, ynum, znum);
	for i = 1:znum;
		IM(:,:,i)  = imread(MultiTiffFileName, i);
	end;

function IM2 = RemapVolImage(IM, p);
	[xn,yn,zn] = size(IM);
	XX  = [1:xn];
	YY  = [(p.xp/p.yp):(p.xp/p.yp):yn]';
	ZZ  = [(p.xp/p.zp):(p.xp/p.zp):zn];
	IM2 = interpn([1:xn],[1:yn],[1:zn],IM, XX, YY, ZZ,'nearest',0);


%%%
%%% Smoothing
%%%

function IM = Smoothing(IM, Radius);

	IM = imdilate(IM, strel('sphere', Radius));
	IM = imerode(IM, strel('sphere', Radius));


%%%
%%% Obtain smooth mesh
%%%

function  [node, elem] = ObtainSmoothMesh(IM, p)

%	[node,  elem,  face] = cgalv2m(IM, p.opt, p.maxvol);
	[node, elem ,regions,holes]=v2s(IM,0.5,p.opt,'cgalsurf')

%	face  = unique(face(:,1:3),'rows');

%	[node,elem]=meshresample(node,elem, 0.5);
%	node = sms(node,elem, 30, 0.5, 'laplacianhc');
%	[node,elem]=meshresample(node,elem, 0.5);

