%%%
%%%
%%%
function simpleplot

	clear;
	Addpaths();
	p = ParamClass;
	load('InsideOut_VolMesh170924.mat'); % ,'node','elem','face'

	figure;
	xlabel('(\mum)');
	ylabel('(\mum)');
	zlabel('(\mum)');
	hold on;
	plotmesh(node*p.xp /1000, elem,'facecolor','y'); 
	view(p.az,p.el);

	saveas(gca, 'ECS.png');% Dendrite Axon Glia UnID

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


