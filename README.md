# Filled_ECS_Mesh

1) main_MeshingObjects.m
 This program loads 3D annotated data as stacked tiff images (16bit grayscale), and 
 resamples it as a spatially isotropic matlab 3D matrix.
 The annotated target objects are smoothed by spatial filters. then,
 the surface meshes of those objects are obtained by iso2mesh "v2s" function, and 
 their vertcies are furhter smoothed.
 Then, the variables of surface meshes Vol{nodes, faces} are saved as 'STL170922.mat'.

2) main_ECS_VolMesh.m
 This program loads 3D annotated data as stacked tiff images (16bit grayscale), and 
 resamples it as a spatially isotropic matlab 3D matrix.
 The annotated target objects are smoothed by spatial filters.
 Then, everything is inside-out, and the extracellular space (ECS) is obtained.
 Its surface mesh is obtained by iso2mesh "v2s" function
 (saved as 'InsideOut_SurfMesh170924.mat'), 
 as well as its volume mesh is obtained by iso2mesh "v2m" function 
 (saved as 'InsideOut_VolMesh170924.mat' and './TestAbaqus.inp').
 
3) simple_Plot.m
This program loads the variables of surface meshes (Vol{nodes, faces} in 'STL170922.mat'),
and plot them.

4) ParamClass:
 Parameters.
 
 
