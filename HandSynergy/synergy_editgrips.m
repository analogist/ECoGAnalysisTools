function [ finalpos ] = synergy_editgrips( initialposfile )
%SYNERGY_EDITGRIPS Uses an editor to edit the grips loaded
% into the argin

    round4 = @(x) round(x*1000)/1000;

    model = 'Adroit_Hand';
    so = mjcVizualizer;
    mjcLoadModel(so, which([model '.xml']));
    m = mjcGetModel(so);
    V0 = zeros(m.nq,1);
    
    initialpos = csvread_if_file(initialposfile);
    if(size(initialpos, 1) ~= 24)
        error('initialpos must be [24xn]');
    end
    mjcPlot(so, initialpos(:, 1), V0);
    
    %% make sliders and buttons
    sliderwindow = figure('position', [600 100 600 800]);
    sliderarray = cell(1, m.njnt);
    sliderdisp = cell(1, m.njnt);
    finalpos = double(initialpos);
    
    % all the sliders and slider numbers
    for jointno = 1:m.njnt
        % 0-50 joint display, 50+500=550, 550+50=600
        slidernames = {'WRJ1', 'WRJ0',...
            'FF MCP/A', 'FF MCP/F', 'FF PIP', 'FF DIP',...
            'MF MCP/A', 'MF MCP/F', 'MF PIP', 'MF DIP',...
            'RF MCP/A', 'RF MCP/F', 'RF PIP', 'RF DIP',...
            'IMC Art', 'LF MCP/A', 'LF MCP/F', 'LF PIP', 'LF DIP',...
            'THBase', 'THProximal', 'THHub', 'THMiddle', 'THDistal'};
        uicontrol('Style', 'text',...
            'Position', [0 750-30*jointno 50 20], 'String',...
            slidernames{jointno}); % Label names
        sliderarray{jointno} = uicontrol('Style', 'slider',...
            'Position', [50 750-30*jointno 500 20],...
            'Min', m.jnt_range(jointno, 1),...
            'Max', m.jnt_range(jointno, 2),...
            'Value', initialpos(jointno, 1));
        sliderdisp{jointno} = uicontrol('Style', 'text',...
            'Position', [550 750-30*jointno 50 20], 'String',...
            num2str(round4(initialpos(jointno, 1))));
    end
    
    % dropdown
    dropdownlist=cellfun(@num2str,num2cell(1:size(initialpos,2)),'UniformOutput',0);
    uicontrol('Style', 'popupmenu', 'String', dropdownlist,...
        'Position', [100 750 50 30], 'Callback', @setposture)
    
    % the "output" button
    uicontrol('Style', 'pushbutton', 'String', 'Output',...
        'Position', [30 750 50 30], 'Callback', @dispposition);
    % the "quit" button
    uicontrol('Style', 'pushbutton', 'String', 'Quit',...
        'Position', [400 750 50 30], 'Callback', @endtheloop);
    
    %% Main loop w posture switching
    iter = uint32(1);
    endloop_pushed = logical(false);
    postureno = 1;
    
    while(~endloop_pushed)

        for jointno = 1:m.njnt
            finalpos(jointno, postureno) = get(sliderarray{jointno}, 'Value');
            set(sliderdisp{jointno}, 'String', num2str(round4(finalpos(jointno, postureno))));
        end
        drawnow;
        if(~mod(iter, 5))
            mjcPlot(so, finalpos(:, postureno), zeros(m.nv, 1));
        end
        
        iter = iter+1;
    end
    mjcClose(so);
    delete(sliderwindow);

    %% Callback functions for uicontrol
    function dispposition(~, ~)
        clc;
        disp(finalpos(:, postureno));
    end

    function endtheloop(~, ~)
         endloop_pushed = true;
    end

    function setposture(hObject, ~)
        postureno = get(hObject, 'Value');
        % you'd have to index otherwise, but in this case Value = value you want numerically  
        for jointno = 1:m.njnt
            set(sliderarray{jointno}, 'Value', finalpos(jointno, postureno));
            set(sliderdisp{jointno}, 'String', num2str(round4(finalpos(jointno, postureno))));
        end
    end
end


