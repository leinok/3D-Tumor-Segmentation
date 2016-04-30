function [volume] = segmentation(startFile, endFile, startPath, endPath, choice)

currentMatrix = makeMatrix(startFile, endFile, startPath, endPath);

if choice == 0
    [u, erriter, i, timet, volume] = CMF3D_Cut(currentMatrix);
elseif choice == 1
    volume = interactive_graph_cuts3D(currentMatrix);
end

end