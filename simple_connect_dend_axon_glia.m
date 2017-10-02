%%%
%%%
%%%
function simpleplot

	clear;
	Addpaths();
	p = ParamClass;

	load('STL170922.mat');
	SegNUM = numel(Obj(:,1));
	COLNUM   = SegNUM+1;

	col = colormap(colorcube(COLNUM));


	Dendrite = [10, 11, 27, 38, 39, 53, 56, 57, 63, 67, 72, ...
		128, 140, 143, 146, 153, 156, 165, 213, 224, 248,...
		271, 286, 298, 299, 306, 322, 327, 340, 359, 363,...
		366, 379, 381, 384, 389, 393, 399, 411, 413];
	
	Axon     = [13, 15, 16, 17, 19, 30, 31, 34, 37, 45,...
		46, 49, 52, 54, 55, 58, 60, 61, 62, 68, 74, 78, 82,...
		87, 90, 91, 92, 94, 95, 96, 97, 99, 102,...
		103, 106, 108, 110, 111, 112, 113, 114, 123, 125,...
		126, 130, 131, 142, 145, 152, 155, 157, 158, 166,...
		168, 172, 173, 174, 177, 179, 180, 181, 182, 184,...
		186, 187, 191, 192, 195, 201, 202, 206, 209, 210,...
		211, 212, 215, 216, 217, 219, 221, 225, 226, 227,...
		230, 232, 233, 234, 240, 241, 242, 247, 249, 251,...
		257, 258, 259, 264, 265, 268, 269, 270, 274, 275,...
		278, 281, 283, 290, 291, 294, 300, 303, 309, 314,...
		316, 317, 318, 320, 321, 325, 328, 330, 332, 333,...
		334, 336, 339, 350, 352, 353, 354, 355, 356, 358,...
		364, 367, 369, 371, 372, 376, 378, 386, 391, 394,...
		397, 401, 406, 412, 414, 419, 420, 428, 432, 444, 448];

	Glia = [1, 48, 71, 81, 104, 178, 183, 207, 239, 245, 277,...
		280, 302, 335, 337, 373, 405, 433];
	Axon     = Axon + 1;
	Dendrite = Dendrite + 1;
	Glia     = Glia + 1;
	
%%%%%
%%%%%
%%%%%
	node = [];
	face = [];
	for i = Dendrite; % Dendrite Axon Glia UnID Axon(DA_ID) [1:SegNUM];
		if isempty(node)
			node = Obj{i,1};
			face = Obj{i,2};
		else
			n = numel(node(:,1));
			node = [node; Obj{i,1}];
			face = [face; Obj{i,2}+n];
		end;
	end;
	node = node*p.xp/1000;
	savestl(node,face,'dend.stl','Dendrite');
%%%%%
%%%%%
%%%%%
	node = [];
	face = [];
	for i = Axon; % Dendrite Axon Glia UnID Axon(DA_ID) [1:SegNUM];
		if isempty(node)
			node = Obj{i,1};
			face = Obj{i,2};
		else
			n = numel(node(:,1));
			node = [node; Obj{i,1}];
			face = [face; Obj{i,2}+n];
		end;
	end;
	node = node*p.xp/1000;
	savestl(node,face,'Axon.stl','Axon');
%%%%%
%%%%%
%%%%%
	node = [];
	face = [];
	for i = Glia; % Dendrite Axon Glia UnID Axon(DA_ID) [1:SegNUM];
		if isempty(node)
			node = Obj{i,1};
			face = Obj{i,2};
		else
			n = numel(node(:,1));
			node = [node; Obj{i,1}];
			face = [face; Obj{i,2}+n];
		end;
	end;
	node = node*p.xp/1000;
	savestl(node,face,'glia.stl','Glia');%%%%%
%%%%%
%%%%%




%%%
%%%
%%%

function Addpaths()

	addpath('..\Matlab');
	addpath('..\Matlab\iso2mesh');
 	addpath('..\Matlab\STLRead');
 	addpath('..\Matlab\FastMarching_version3b');
	addpath('..\Matlab\FastMarching_version3b\functions');
	addpath('..\Matlab\FastMarching_version3b\shortestpath');
	addpath('..\Matlab\distancePointLine');


