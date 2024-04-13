% Function that displays aircraft sizing results

function [] = ReportFunction(inputs)
missionnames = fieldnames(inputs.Missions);
for i=1:size(missionnames,1)
missionname = missionnames{i};
missionoutput = getfield(inputs.Missionoutputs, missionname);
missioninput = getfield(inputs.Missions, missionname);
fprintf('%s \n','------------------------------------          ')
fprintf(strcat(missionname, ' Mission\n'))
fprintf('%s%7.0f%s \n','Takeoff Gross Weight:  ',missionoutput.Wmat(1),' lbs')
fprintf('%s%7.0f%s \n','Fuel Weight:           ',missionoutput.Wfuel,' lbs')
fprintf('%s%7.0f%s \n','Payload Weight:        ',missioninput.w_payload,' lbs')
fprintf('%s%7.0f%s \n','Empty Weight:          ',missionoutput.EmptyWeight.We,' lbs')
fprintf('%s%7.3f%s \n','We/W0:                 ',missionoutput.EmptyWeight.fe,'')
fprintf('%s \n','------------------------------------          ')
end

fprintf('%s \n','------------------------------------          ')
fprintf('Wing Parameters\n')
fprintf('%s%7.3f%s \n','Aspect Ratio:          ',missionoutput.GeometryOutput.AR,'')
fprintf('%s%7.0f%s \n','Wing Loading:          ',inputs.PerformanceInputs.WS,' lbs/ft^2')
fprintf('%s%7.0f%s \n','Wing Area:             ',missionoutput.GeometryOutput.Sw,' ft^2')
fprintf('%s%7.0f%s \n','Wing Span:             ',inputs.GeometryInputs.b,' ft')
fprintf('%s \n','------------------------------------          ')


% inputs.GeometryInputs.AR*inputs.PerformanceInputs.WS/inputs.TOGW
% fprintf('%s \n','Empty Weight breakdown          ')
% fprintf('%s \n','____________________________________          ')
% fprintf('%s%6.0f%s \n','           Wing:        ',inputs.EmptyWeight.Wwing,' lbs')
% fprintf('%s%6.0f%s \n','           Fuselage:    ',inputs.EmptyWeight.Wfus,' lbs')
% fprintf('%s%6.0f%s \n','           Vtail:       ',inputs.EmptyWeight.WVtail,' lbs')
% fprintf('%s%6.0f%s \n','           Htail:       ',inputs.EmptyWeight.WHtail,' lbs')
% fprintf('%s%6.0f%s \n','           Engines:     ',inputs.EmptyWeight.Weng,' lbs')
% fprintf('%s%6.0f%s \n','           Gear:        ',inputs.EmptyWeight.Wgear,' lbs')
% fprintf('%s%6.0f%s \n','           Misc:        ',inputs.EmptyWeight.Wmisc,' lbs')
% fprintf('%s \n','------------------------------------          ')
% fprintf('%s \n','Costs          ')
% fprintf('%s \n','____________________________________          ')
% fprintf('%s%6.0f%s \n','Acquisition Cost:       $ ',inputs.AqCostOutput.AqCost,' ')
% fprintf('%s%6.0f%s \n','Operating Cost (DOC+I): $   ',inputs.OpCostOutput.DOC_leg,' /leg')
% fprintf('%s%6.0f%s \n','Operating Cost (DOC+I): $   ',inputs.OpCostOutput.DOC_BH,' /BH')
