function [maxVMStress, scriptRuntime] = MaintenancePlate_StressExtract_Function(W1, W2, R, t)
    % This function writes input parameters to 'MaintenancePlate_StressExtract_Input.txt',
    % runs the Abaqus script 'MaintenancePlate_StressExtract.py', and extracts the 
    % results from 'MaintenancePlate_StressExtract_Output.txt'. To run this function,
    % ensure that Abaqus is not open, otherwise it will give an error.
    %
    % Function inputs:
    %   W1 - Width (m)
    %   W2 - Width (m)
    %   R - Radius (m)
    %   t - Thickness (m)
    %
    % Function outputs:
    %   maxVMStress - Maximum Von Mises stress (MPa) from the Abaqus simulation
    %   scriptRuntime - Runtime (seconds) of the Abaqus simulation
    %
    % This function can be run in the command window of Matlab like so:
    %   [maxVMStress, scriptRuntime] = MaintenancePlate_StressExtract_Function(0.6,0.2,0.06,0.02)
    
    % Delete the output file if it exists
    outputFile = 'MaintenancePlate_StressExtract_Output.txt';
    if exist(outputFile, 'file')
        delete(outputFile);
    end
    
    
    % Write input parameters to a text file
    inputFile = 'MaintenancePlate_StressExtract_Input.txt';
    fileID = fopen(inputFile, 'w');
    fprintf(fileID, '%0.8f\n%0.8f\n%0.8f\n%0.8f\n', W1, W2, R, t);
    fclose(fileID);
    
    % Run the Abaqus Python script
    command = 'abaqus cae nogui=MaintenancePlate_StressExtract.py -- MaintenancePlate';
    system(command);
    
    % Read results from a text file
    fileID = fopen(outputFile, 'r');
    if fileID == -1
        error('Error: Could not open the output file. Please ensure that Abaqus is not open.');
    end
    
    % Extract max Von Mises stress and runtime
    line1 = fgetl(fileID); 
    maxVMStress = sscanf(line1, 'Max Von Mises Stress: %f MPa');
    line2 = fgetl(fileID); 
    scriptRuntime = sscanf(line2, 'Script Runtime: %f seconds');
    fclose(fileID);
end
