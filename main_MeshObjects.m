%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mod by H Urakubo                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%%%
%%%
function  main_MeshingObjects

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

	TNUM = [1:SegNUM];
%	TNUM = [1,3,11];

	Obj = cell(numel(TNUM),2);
	for i = 1:numel(TNUM);
		IMt = (IM2 == TNUM(i));
		IM3 = Smoothing(IMt, p.Radius);
		[Obj{i,1}, Obj{i,2}] = ObtainSmoothMesh(IM3, p);
	end;


%%%
%%% Plot and save
%%%
	save('STL170922.mat','Obj');

	figure;
	hold on;
	for i = 1:numel(TNUM);
		plotmesh(Obj{i,1}, Obj{i,2},'facecolor',col(TNUM(i),:)); 
	end;
	view(p.az,p.el);



%		fv1   = isosurface(YY,XX,ZZ,IM3,0.5);
%		p1    = patch(fv1,'FaceColor','b','EdgeColor','none','FaceAlpha',.5);


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

	[node,elem]=meshresample(node,elem, 0.5);
	node = sms(node,elem, 30, 0.5, 'laplacianhc');
	[node,elem]=meshresample(node,elem, 0.5);

