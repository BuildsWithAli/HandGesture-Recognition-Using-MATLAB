function HandGestureGUI()
 
    camList = {};
    try
        camList = webcamlist();
    catch
        
    end

    fig = figure( ...
        'Name',        'Hand Gesture Recognition System', ...
        'NumberTitle', 'off', ...
        'MenuBar',     'none', ...
        'ToolBar',     'none', ...
        'Color',       [0.13 0.13 0.16], ...
        'Position',    [60 40 1430 750], ...
        'Resize',      'off', ...
        'CloseRequestFcn', @onClose);
 
    uicontrol(fig, 'Style','text', ...
        'String', 'Hand Gesture Recognition Using Image Processing', ...
        'Units','pixels', 'Position',[0 716 1430 34], ...
        'FontSize',15, 'FontWeight','bold', ...
        'ForegroundColor',[1 1 1], ...
        'BackgroundColor',[0.14 0.32 0.58]);

    uicontrol(fig, 'Style','text', ...
        'String', 'Offline MATLAB  |  Image Upload  +  Live Webcam Detection', ...
        'Units','pixels', 'Position',[0 692 1430 24], ...
        'FontSize',9, ...
        'ForegroundColor',[0.70 0.75 0.85], ...
        'BackgroundColor',[0.13 0.13 0.16]);

    
    panBG = [0.17 0.17 0.21];

    uicontrol(fig,'Style','frame','Units','pixels', ...
        'Position',[8 8 214 682],'BackgroundColor',panBG);

    sectionLabel(fig, [18 658 194 20], 'IMAGE MODE', panBG);

    btnUpload = makeBtn(fig, [18 618 194 36], '  Upload Image', ...
        [0.18 0.45 0.78], @uploadImage);
    btnProcess = makeBtn(fig, [18 574 194 36], '  Process & Detect', ...
        [0.12 0.60 0.36], @processImage);
    btnClear = makeBtn(fig, [18 532 194 36], '  Clear All', ...
        [0.65 0.18 0.18], @clearAll);
 
    sectionLabel(fig, [18 504 194 20], 'WEBCAM MODE', panBG);
 
    uicontrol(fig,'Style','text','String','Select Camera:', ...
        'Units','pixels','Position',[18 484 194 16], ...
        'FontSize',8,'ForegroundColor',[0.75 0.75 0.85], ...
        'BackgroundColor',panBG,'HorizontalAlignment','left');

    if isempty(camList)
        camItems = {'No camera found'};
    else
        camItems = camList;
    end
    ddCam = uicontrol(fig,'Style','popupmenu', ...
        'String', camItems, ...
        'Units','pixels','Position',[18 460 194 24], ...
        'FontSize',9,'BackgroundColor',[0.22 0.22 0.27], ...
        'ForegroundColor',[1 1 1]);

    btnStartCam = makeBtn(fig, [18 420 194 36], '  Start Webcam', ...
        [0.50 0.18 0.62], @startWebcam);
    btnStopCam  = makeBtn(fig, [18 378 194 36], '  Stop Webcam', ...
        [0.35 0.35 0.38], @stopWebcam);
    set(btnStopCam, 'Enable','off');
 
    uicontrol(fig,'Style','frame','Units','pixels', ...
        'Position',[18 370 194 2],'BackgroundColor',[0.35 0.35 0.45]);
 
    uicontrol(fig,'Style','text','String','Detected Gesture', ...
        'Units','pixels','Position',[18 348 194 18], ...
        'FontSize',8,'FontWeight','bold', ...
        'ForegroundColor',[0.65 0.70 0.85],'BackgroundColor',panBG);

    lblGesture = uicontrol(fig,'Style','text','String','---', ...
        'Units','pixels','Position',[18 308 194 40], ...
        'FontSize',13,'FontWeight','bold', ...
        'ForegroundColor',[0.25 0.92 0.55], ...
        'BackgroundColor',[0.12 0.22 0.16], ...
        'HorizontalAlignment','center');

    uicontrol(fig,'Style','text','String','Confidence', ...
        'Units','pixels','Position',[18 288 194 18], ...
        'FontSize',8,'FontWeight','bold', ...
        'ForegroundColor',[0.65 0.70 0.85],'BackgroundColor',panBG);

    lblConf = uicontrol(fig,'Style','text','String','---', ...
        'Units','pixels','Position',[18 264 194 24], ...
        'FontSize',11,'ForegroundColor',[0.40 0.70 1.0], ...
        'BackgroundColor',panBG,'HorizontalAlignment','center');

    uicontrol(fig,'Style','text','String','Fingers Detected', ...
        'Units','pixels','Position',[18 244 194 18], ...
        'FontSize',8,'FontWeight','bold', ...
        'ForegroundColor',[0.65 0.70 0.85],'BackgroundColor',panBG);

    lblFingers = uicontrol(fig,'Style','text','String','---', ...
        'Units','pixels','Position',[18 220 194 24], ...
        'FontSize',11,'ForegroundColor',[0.80 0.55 1.0], ...
        'BackgroundColor',panBG,'HorizontalAlignment','center');
 
    uicontrol(fig,'Style','frame','Units','pixels', ...
        'Position',[18 212 194 2],'BackgroundColor',[0.35 0.35 0.45]);
 
    uicontrol(fig,'Style','text','String','Detection History', ...
        'Units','pixels','Position',[18 194 194 18], ...
        'FontSize',8,'FontWeight','bold', ...
        'ForegroundColor',[0.65 0.70 0.85],'BackgroundColor',panBG);

    lstHistory = uicontrol(fig,'Style','listbox', ...
        'Units','pixels','Position',[18 15 194 178], ...
        'FontSize',7,'Max',200, ...
        'BackgroundColor',[0.14 0.14 0.18], ...
        'ForegroundColor',[0.80 0.85 0.95]);
 
    axOrig    = makeImagePanel(fig, [232 382 468 318], 'Original Image',          [0.25 0.50 0.90]);
    axMask    = makeImagePanel(fig, [708 382 468 318], 'Skin Segmentation Mask',  [0.20 0.78 0.45]);
    axMasked  = makeImagePanel(fig, [232  42 468 318], 'Masked Hand Region',      [0.72 0.35 0.90]);
    axOverlay = makeImagePanel(fig, [708  42 468 318], 'Feature Overlay & Result',[1.00 0.60 0.20]);

    
    uicontrol(fig,'Style','frame','Units','pixels', ...
        'Position',[1190 8 222 682],'BackgroundColor',panBG);
 
    sectionLabel(fig, [1200 658 200 20], 'FEATURE INSPECTOR', panBG);
    
    lblFI_Area = uicontrol(fig,'Style','text','String','Area: ---', ...
        'Units','pixels','Position',[1200 630 200 18],'FontSize',9,...
        'ForegroundColor',[0.8 0.8 0.8],'BackgroundColor',panBG,'HorizontalAlignment','left');
    lblFI_Perim = uicontrol(fig,'Style','text','String','Perimeter: ---', ...
        'Units','pixels','Position',[1200 610 200 18],'FontSize',9,...
        'ForegroundColor',[0.8 0.8 0.8],'BackgroundColor',panBG,'HorizontalAlignment','left');
    lblFI_Solid = uicontrol(fig,'Style','text','String','Solidity: ---', ...
        'Units','pixels','Position',[1200 590 200 18],'FontSize',9,...
        'ForegroundColor',[0.8 0.8 0.8],'BackgroundColor',panBG,'HorizontalAlignment','left');
    lblFI_Aspect = uicontrol(fig,'Style','text','String','Aspect Ratio: ---', ...
        'Units','pixels','Position',[1200 570 200 18],'FontSize',9,...
        'ForegroundColor',[0.8 0.8 0.8],'BackgroundColor',panBG,'HorizontalAlignment','left');
    lblFI_Centroid = uicontrol(fig,'Style','text','String','Centroid: ---', ...
        'Units','pixels','Position',[1200 550 200 18],'FontSize',9,...
        'ForegroundColor',[0.8 0.8 0.8],'BackgroundColor',panBG,'HorizontalAlignment','left');
 
    uicontrol(fig,'Style','frame','Units','pixels','Position',[1200 532 200 2],'BackgroundColor',[0.35 0.35 0.45]);
    sectionLabel(fig, [1200 504 200 20], 'EXPORT & TOOLS', panBG);
    btnSaveImg = makeBtn(fig, [1200 460 200 36], '  Save Overlay Image', [0.60 0.40 0.12], @saveOverlayImage);
    btnExportCSV = makeBtn(fig, [1200 416 200 36], '  Export History CSV', [0.20 0.60 0.20], @exportCSV);
    btnShowStats = makeBtn(fig, [1200 372 200 36], '  Show Statistics', [0.50 0.20 0.60], @showStats);
 
    uicontrol(fig,'Style','frame','Units','pixels','Position',[1200 362 200 2],'BackgroundColor',[0.35 0.35 0.45]);
    sectionLabel(fig, [1200 334 200 20], 'DIP TOOLKIT', panBG);
    btnSkel    = makeBtn(fig, [1200 296 200 28], '  Hand Skeleton',      [0.30 0.45 0.50], @showSkeleton);
    btnEdge    = makeBtn(fig, [1200 260 200 28], '  Canny Edges',        [0.30 0.45 0.50], @showEdges);
 
    uicontrol(fig,'Style','frame','Units','pixels','Position',[1200 244 200 2],'BackgroundColor',[0.35 0.35 0.45]);
    sectionLabel(fig, [1200 216 200 20], 'WEBCAM CALIBRATION', panBG);
    btnSetBg   = makeBtn(fig, [1200 178 200 32], '  Set Background', [0.80 0.40 0.20], @setBackground);
 
    uicontrol(fig,'Style','frame','Units','pixels','Position',[1200 162 200 2],'BackgroundColor',[0.35 0.35 0.45]);
    sectionLabel(fig, [1200 134 200 20], 'TRANSLATOR', panBG);
    lblTranslation = uicontrol(fig,'Style','text','String','---', ...
        'Units','pixels','Position',[1200 110 200 22],'FontSize',12,'FontWeight','bold',...
        'ForegroundColor',[1 0.8 0.2],'BackgroundColor',panBG,'HorizontalAlignment','center');
 
    lblStatus = uicontrol(fig,'Style','text', ...
        'String','  Ready — Upload an image or start the webcam', ...
        'Units','pixels','Position',[0 0 1430 22], ...
        'FontSize',8,'HorizontalAlignment','left', ...
        'ForegroundColor',[0.70 0.75 0.85], ...
        'BackgroundColor',[0.10 0.10 0.13]);
 
    currentImage = [];
    currentMask  = [];
    bgImage      = [];
    currentFilename = 'Webcam';
    camObj       = [];
    camTimer     = [];
    camRunning   = false;
    lastGesture  = '';
    historyData  = cell(0,4); % Columns: Time, File/Source, Gesture, Confidence
 
    function uploadImage(~,~)
        if camRunning
            setStatus('Stop webcam before uploading an image.');
            return;
        end
        [fname, pname] = uigetfile( ...
            {'*.jpg;*.jpeg;*.png;*.bmp;*.tiff','Image Files (*.jpg,*.png,*.bmp)'}, ...
            'Select a hand image');
        if isequal(fname,0)
            setStatus('Upload cancelled.'); return;
        end

        img = imread(fullfile(pname, fname));
        if size(img,3)==1,  img = cat(3,img,img,img); end
        if size(img,3)==4,  img = img(:,:,1:3);        end
        
        currentFilename = fname;
        currentImage = preprocessImage(img);

        imshow(currentImage, 'Parent', axOrig);
        title(axOrig, fname, 'Color','w','FontSize',8,'Interpreter','none');
        axis(axOrig,'off');

        clearPanels(false);    
        resetLabels();
        setStatus(['Loaded: ' fname '  —  Click "Process & Detect"']);
    end
 
    function processImage(~,~)
        if isempty(currentImage)
            setStatus('Please upload an image first.'); return;
        end
        if camRunning
            setStatus('Stop webcam first.'); return;
        end
        setStatus('Processing...');
        drawnow;
        processFrame(currentImage);
    end
 
    function clearAll(~,~)
        if camRunning, stopWebcam(); end
        currentImage = [];
        bgImage = [];
        currentFilename = 'Webcam';
        clearPanels(true);
        resetLabels();
        set(lstHistory,'String',{});
        lastGesture = '';
        historyData = cell(0,4);
        setStatus('Cleared — ready.');
    end
 
    function startWebcam(~,~)
        if camRunning, return; end
 
        if isempty(camList)
            errordlg('No webcam found or USB Webcam Support Package not installed.', ...
                     'Camera Error');
            return;
        end

        try
            idx = get(ddCam,'Value');
            idx = min(idx, length(camList));

            setStatus('Connecting to camera...');
            drawnow;

            camObj = webcam(idx);
 
            resOptions = camObj.AvailableResolutions;
            target = '640x480';
            if any(strcmp(resOptions, target))
                camObj.Resolution = target;
            else
                camObj.Resolution = resOptions{1};  % fallback to first available
            end

            camRunning = true;
            currentFilename = 'Webcam';
 
            set(btnStartCam,'Enable','off');
            set(btnStopCam, 'Enable','on');
            set(btnUpload,  'Enable','off');
            set(btnProcess, 'Enable','off');
            set(btnClear,   'Enable','off');
 
            camTimer = timer( ...
                'ExecutionMode', 'fixedRate', ...
                'Period',         0.25, ...
                'BusyMode',      'drop', ...   % drop frame if processing is slow
                'TimerFcn',      @timerCallback, ...
                'ErrorFcn',      @timerError);

            start(camTimer);
            setStatus(['Webcam running: ' camList{idx} '  —  Show your hand to the camera']);

        catch ME
            errordlg(['Camera error: ' ME.message], 'Camera Error');
            shutdownCamera();
            setStatus('Camera failed to start.');
        end
    end

    function timerCallback(~,~)
        if ~camRunning || isempty(camObj)
            return;
        end
        try
            frame = snapshot(camObj);
            frame = preprocessImage(frame);
    
            if ~isempty(bgImage)
                diff = imabsdiff(rgb2gray(frame), rgb2gray(bgImage));
                fgMask = diff > 30; 
                fgMask = imopen(fgMask, strel('disk', 3));
                fgMask = imclose(fgMask, strel('disk', 15));
                frame = bsxfun(@times, frame, cast(fgMask, 'like', frame));
            end
            
            processFrame(frame);
        catch
        end
    end
 
    function timerError(~,~)
        shutdownCamera();
        setStatus('Webcam error — stopped.');
    end
 
    function stopWebcam(~,~)
        shutdownCamera();
        setStatus('Webcam stopped.');
    end

    % ---- Shutdown camera safely ----
    function shutdownCamera()
        % Stop and delete timer first
        if ~isempty(camTimer)
            try
                if strcmp(camTimer.Running,'on')
                    stop(camTimer);
                end
                delete(camTimer);
            catch
            end
            camTimer = [];
        end
 
        if ~isempty(camObj)
            try
                clear camObj;
            catch
            end
            camObj = [];
        end

        camRunning = false;
 
        if isvalid(fig)
            set(btnStartCam,'Enable','on');
            set(btnStopCam, 'Enable','off');
            set(btnUpload,  'Enable','on');
            set(btnProcess, 'Enable','on');
            set(btnClear,   'Enable','on');
        end
    end
    function onClose(~,~)
        shutdownCamera();
        delete(fig);
    end
 
    function processFrame(img)
        try
            [mask, maskedImg] = segmentHand(img);
            currentMask       = mask;  
            features          = extractFeatures(mask);
            [gestureName, confidence] = classifyGesture(features);
            imshow(img, 'Parent', axOrig);
            axis(axOrig,'off');
            if camRunning
                title(axOrig,'Live Webcam Feed','Color','w','FontSize',8);
            end
 
            imshow(mask, 'Parent', axMask);
            title(axMask,'Binary Skin Mask','Color','w','FontSize',8);
            axis(axMask,'off');

            imshow(maskedImg, 'Parent', axMasked);
            title(axMasked,'Hand Region Only','Color','w','FontSize',8);
            axis(axMasked,'off');
 
            imshow(img, 'Parent', axOverlay);
            hold(axOverlay,'on');

            if features.area > 500
                bb = features.boundingBox;
 
                rectangle(axOverlay,'Position',bb, ...
                    'EdgeColor',[0.20 0.95 0.35],'LineWidth',2.5);
 
                plot(axOverlay, features.centroid(1), features.centroid(2), ...
                    'r+','MarkerSize',16,'LineWidth',2.5);
 
                B = bwboundaries(mask,'noholes');
                if ~isempty(B)
                    lens = cellfun(@length,B);
                    [~,bi] = max(lens);
                    plot(axOverlay, B{bi}(:,2), B{bi}(:,1), ...
                        'c-','LineWidth',2);
                end
 
                text(axOverlay, bb(1)+5, max(bb(2)-12,15), gestureName, ...
                    'Color','yellow','FontSize',12,'FontWeight','bold', ...
                    'BackgroundColor',[0 0 0 0.6]);
 
                text(axOverlay, bb(1)+5, bb(2)+bb(4)+18, ...
                    sprintf('Fingers: %d', features.fingerCount), ...
                    'Color','cyan','FontSize',10,'FontWeight','bold', ...
                    'BackgroundColor',[0 0 0 0.5]);
            end

            hold(axOverlay,'off');
            title(axOverlay,'Detection Result','Color','w','FontSize',8);
            axis(axOverlay,'off');
 
            set(lblGesture,'String', gestureName);
            set(lblFingers,'String', num2str(features.fingerCount));
            set(lblConf,   'String', confidence);

            switch confidence
                case 'High'
                    set(lblConf,'ForegroundColor',[0.20 0.90 0.45]);
                case 'Medium'
                    set(lblConf,'ForegroundColor',[1.00 0.72 0.20]);
                otherwise
                    set(lblConf,'ForegroundColor',[0.90 0.30 0.30]);
            end
 
            if features.area > 0
                set(lblFI_Area, 'String', sprintf('Area: %.1f', features.area));
                set(lblFI_Perim, 'String', sprintf('Perimeter: %.1f', features.perimeter));
                set(lblFI_Solid, 'String', sprintf('Solidity: %.3f', features.solidity));
                set(lblFI_Aspect, 'String', sprintf('Aspect Ratio: %.3f', features.aspectRatio));
                set(lblFI_Centroid, 'String', sprintf('Centroid: [%.1f, %.1f]', features.centroid(1), features.centroid(2)));
            else
                set(lblFI_Area, 'String', 'Area: ---');
                set(lblFI_Perim, 'String', 'Perimeter: ---');
                set(lblFI_Solid, 'String', 'Solidity: ---');
                set(lblFI_Aspect, 'String', 'Aspect Ratio: ---');
                set(lblFI_Centroid, 'String', 'Centroid: ---');
            end
 
            translationText = '---';
            switch gestureName
                case 'Fist'
                    translationText = 'STOP';
                case 'One finger (point)'
                    translationText = 'LOOK';
                case 'Two fingers (peace)'
                    translationText = 'HELLO';
                case 'Three fingers'
                    translationText = 'PERFECT';
                case 'Four fingers'
                    translationText = 'HELP';
                case 'Open hand (five)'
                    translationText = 'HIGH FIVE';
                case 'No hand detected'
                    translationText = '---';
            end
            set(lblTranslation, 'String', translationText);
 
            if ~strcmp(gestureName, lastGesture) || ~strcmp(currentFilename, 'Webcam')
                lastGesture = gestureName;
                ts    = datestr(now,'HH:MM:SS');
 
                if strcmp(currentFilename, 'Webcam')
                    entry = sprintf('[%s]  %s  (%s)', ts, gestureName, confidence);
                else
                    entry = sprintf('[%s] %s: %s', ts, currentFilename, gestureName);
                end
                
                items = get(lstHistory,'String');
                if isempty(items)
                    set(lstHistory,'String',{entry},'Value',1);
                else
                    newItems = [items; {entry}];
                    set(lstHistory,'String',newItems,'Value',length(newItems));
                end
 
                historyData(end+1,:) = {ts, currentFilename, gestureName, confidence};
  
                set(lstHistory, 'ListboxTop', length(get(lstHistory,'String')));
            end

            setStatus(['Detection: ' gestureName '  |  Confidence: ' confidence]);
            drawnow limitrate;

        catch ME
            setStatus(['Processing error: ' ME.message]);
        end
    end

    function resetLabels()
        set(lblGesture,'String','---','ForegroundColor',[0.25 0.92 0.55]);
        set(lblConf,   'String','---','ForegroundColor',[0.40 0.70 1.00]);
        set(lblFingers,'String','---');
        
        set(lblFI_Area, 'String', 'Area: ---');
        set(lblFI_Perim, 'String', 'Perimeter: ---');
        set(lblFI_Solid, 'String', 'Solidity: ---');
        set(lblFI_Aspect, 'String', 'Aspect Ratio: ---');
        set(lblFI_Centroid, 'String', 'Centroid: ---');
        
        set(lblTranslation, 'String', '---');
    end

    function clearPanels(clearAll_flag)
        if clearAll_flag
            cla(axOrig);    axis(axOrig,'off');
        end
        cla(axMask);    axis(axMask,'off');
        cla(axMasked);  axis(axMasked,'off');
        cla(axOverlay); axis(axOverlay,'off');
    end

    function setStatus(msg)
        set(lblStatus,'String',['  ' msg]);
        drawnow limitrate;
    end

    function saveOverlayImage(~,~)
        if isempty(currentImage)
            setStatus('No image to save.'); return;
        end
        [fname, pname] = uiputfile('*.png', 'Save Overlay Image As');
        if isequal(fname,0), return; end
 
        frame = getframe(axOverlay);
        imwrite(frame.cdata, fullfile(pname, fname));
        setStatus(['Saved image to ' fname]);
    end

    function exportCSV(~,~)
        if isempty(historyData)
            setStatus('History is empty. Nothing to export.'); return;
        end
        [fname, pname] = uiputfile('*.csv', 'Save History As CSV');
        if isequal(fname,0), return; end
        
        fullpath = fullfile(pname, fname);
        try
            T = cell2table(historyData, 'VariableNames', {'Time', 'Source', 'Gesture', 'Confidence'});
            writetable(T, fullpath);
            setStatus(['Exported history to ' fname]);
        catch ME
            setStatus(['Export failed: ' ME.message]);
        end
    end

    function showStats(~,~)
        if isempty(historyData)
            setStatus('No data to show statistics.'); return;
        end
        
        gestures = historyData(:,3);
        [uniqueGestures, ~, idx] = unique(gestures);
        counts = accumarray(idx, 1);
        
        statFig = figure('Name', 'Session Statistics', 'NumberTitle', 'off', 'Color', [0.13 0.13 0.16], 'Position', [100, 100, 650, 450]);
        ax = axes('Parent', statFig, 'Color', [0.13 0.13 0.16], 'XColor', 'none', 'YColor', 'none');
 
        explode = zeros(1, length(counts));
        [~, maxIdx] = max(counts);
        explode(maxIdx) = 1; 
        
        p = pie(ax, counts, explode);
 
        pText = findobj(p, 'Type', 'text');
        set(pText, 'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');
 
        pPatches = findobj(p, 'Type', 'Patch');
        set(pPatches, 'EdgeColor', [0.13 0.13 0.16], 'LineWidth', 2);
        
        title(ax, 'Gesture Detection Breakdown', 'Color', 'w', 'FontSize', 14, 'FontWeight', 'bold');
 
        lgd = legend(ax, uniqueGestures, 'Location', 'eastoutside');
        set(lgd, 'TextColor', 'w', 'Color', [0.2 0.2 0.25], 'EdgeColor', 'none', 'FontSize', 11);
    end
    
    function showSkeleton(~,~)
        if isempty(currentMask)
            setStatus('Process an image first to view skeleton.'); return;
        end
        skel = bwskel(currentMask);
        
        figSkel = figure('Name', 'DIP: Morphological Skeleton', 'NumberTitle', 'off', 'Color', [0.13 0.13 0.16]);
        ax = axes('Parent', figSkel, 'Color', [0.13 0.13 0.16], 'XColor', 'w', 'YColor', 'w');
        imshow(skel, 'Parent', ax);
        title(ax, 'Hand Skeleton (bwskel)', 'Color', 'w');
    end

    function showDistance(~,~)
        if isempty(currentMask)
            setStatus('Process an image first to view distance transform.'); return;
        end
        dist = bwdist(~currentMask);
        
        figDist = figure('Name', 'DIP: Distance Transform', 'NumberTitle', 'off', 'Color', [0.13 0.13 0.16]);
        ax = axes('Parent', figDist, 'Color', [0.13 0.13 0.16], 'XColor', 'w', 'YColor', 'w');
        imshow(dist, [], 'Parent', ax, 'Colormap', jet);
        colorbar(ax, 'Color', 'w');
        title(ax, 'Distance Transform (Heatmap)', 'Color', 'w');
    end

    function showEdges(~,~)
        if isempty(currentMask)
            setStatus('Process an image first to view edges.'); return;
        end
        edges = edge(currentMask, 'canny');
        
        figEdge = figure('Name', 'DIP: Canny Edge Detection', 'NumberTitle', 'off', 'Color', [0.13 0.13 0.16]);
        ax = axes('Parent', figEdge, 'Color', [0.13 0.13 0.16], 'XColor', 'w', 'YColor', 'w');
        imshow(edges, 'Parent', ax);
        title(ax, 'Canny Edges', 'Color', 'w');
    end

    function showColorSpaces(~,~)
        if isempty(currentImage)
            setStatus('Load an image first to view color spaces.'); return;
        end
        
        ycbcr = rgb2ycbcr(currentImage);
        hsv_img = rgb2hsv(currentImage);
        
        figColor = figure('Name', 'DIP: Color Spaces (YCbCr & HSV)', 'NumberTitle', 'off', 'Color', [0.13 0.13 0.16], 'Position', [100 100 900 600]);
 
        ax1 = subplot(2,3,1, 'Parent', figColor); imshow(ycbcr(:,:,1), 'Parent', ax1); title(ax1, 'Y (Luminance)', 'Color', 'w');
        ax2 = subplot(2,3,2, 'Parent', figColor); imshow(ycbcr(:,:,2), 'Parent', ax2); title(ax2, 'Cb (Blue-difference)', 'Color', 'w');
        ax3 = subplot(2,3,3, 'Parent', figColor); imshow(ycbcr(:,:,3), 'Parent', ax3); title(ax3, 'Cr (Red-difference)', 'Color', 'w');
 
        ax4 = subplot(2,3,4, 'Parent', figColor); imshow(hsv_img(:,:,1), 'Parent', ax4); title(ax4, 'H (Hue)', 'Color', 'w');
        ax5 = subplot(2,3,5, 'Parent', figColor); imshow(hsv_img(:,:,2), 'Parent', ax5); title(ax5, 'S (Saturation)', 'Color', 'w');
        ax6 = subplot(2,3,6, 'Parent', figColor); imshow(hsv_img(:,:,3), 'Parent', ax6); title(ax6, 'V (Value)', 'Color', 'w');
    end

    function applyAutoContrast(~,~)
        if isempty(currentImage)
            setStatus('Load an image first to apply Auto-Contrast.'); return;
        end
 
        enhanced = zeros(size(currentImage), 'like', currentImage);
        for i = 1:3
            enhanced(:,:,i) = imadjust(currentImage(:,:,i));
        end
        
        currentImage = enhanced;
 
        setStatus('Auto-Contrast applied. Reprocessing...');
        imshow(currentImage, 'Parent', axOrig);
        title(axOrig, [currentFilename ' (Enhanced)'], 'Color','w','FontSize',8,'Interpreter','none');
        processFrame(currentImage);
    end

    function setBackground(~,~)
        if ~camRunning || isempty(camObj)
            setStatus('Start webcam first to set background.'); return;
        end
        setStatus('Capturing background...');
        drawnow;
        pause(0.5);
        
        bgFrame = snapshot(camObj);
        bgImage = preprocessImage(bgFrame);
        setStatus('Background captured successfully.');
    end

end  

function ax = makeImagePanel(fig, pos, titleStr, titleColor)
    bgDark = [0.10 0.10 0.13];
    p = uipanel(fig,'Units','pixels','Position',pos, ...
        'BackgroundColor',bgDark,'BorderType','line', ...
        'HighlightColor',titleColor,'BorderWidth',2, ...
        'Title',titleStr,'ForegroundColor',titleColor, ...
        'FontSize',9,'FontWeight','bold');
    ax = axes('Parent',p,'Units','normalized', ...
              'Position',[0.01 0.01 0.98 0.92], ...
              'Color',bgDark,'XColor',bgDark,'YColor',bgDark);
    axis(ax,'off');
end
 
function btn = makeBtn(fig, pos, label, bgColor, callback)
    btn = uicontrol(fig,'Style','pushbutton', ...
        'String',label,'Units','pixels','Position',pos, ...
        'FontSize',10,'FontWeight','bold', ...
        'BackgroundColor',bgColor,'ForegroundColor',[1 1 1], ...
        'Callback',callback);
end
 
function sectionLabel(fig, pos, txt, panBG)
    uicontrol(fig,'Style','text','String',txt, ...
        'Units','pixels','Position',pos, ...
        'FontSize',8,'FontWeight','bold', ...
        'ForegroundColor',[0.55 0.60 0.75], ...
        'BackgroundColor',panBG, ...
        'HorizontalAlignment','center');
end