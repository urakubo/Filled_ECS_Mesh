%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mod by H Urakubo                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%%%
%%%
function  main_Volumes

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

	Vol = zeros(numel(TNUM),1);
	for i = 1:numel(TNUM);
		IMt = (IM2 == TNUM(i));
		IM3      = Smoothing(IMt, p.Radius);
		Vol(i,1) = sum(sum(sum(IM3)));
	end;

%%%
%%% Plot and save
%%%
	save('VOL170922.mat','Vol');


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



