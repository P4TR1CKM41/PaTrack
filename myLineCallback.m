function myLineCallback(LineH, EventData, LineList,identifiercellarray )
              % The handle
              title('Click on a line!')
% % % disp(get(LineH, 'YData'));      % The Y-data
% % % disp(find(LineList == LineH));  % Index of the active line in the list
index = (find(LineList == LineH));
set(LineList, 'LineWidth', 0.5);
set(LineH,    'LineWidth', 2.5);
title (['You clicked on ', identifiercellarray{index}], 'interpreter', 'none')
uistack(LineH, 'top');  % Set active line before all others
end