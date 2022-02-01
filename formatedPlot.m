%---------------------------------------------
% Function to plot a graph and save a figure in .eps or .png format
%---------------------------------------------
function fig = formatedPlot(pens,varargin)
set(0,'defaulttextInterpreter','latex') % latex axis labels

% Parses input configuration
input = struct(varargin{:});

% Type of plot
if isfield(input, 'type')
    graphType = input.type;
else
    graphType = 'plot';
end

% Default configuration
config = struct('x0',5,'y0',2.5,'titleFontSize',14,...
    'fontName','Times','textColor','k','legPos','northeast',...
    'xLim',[-inf,inf],'yLim',[-inf,inf],'xLabel','','yLabel','',...
    'name','Untitled','folder','./','format','png');

% Graphics configuration
if (strcmp(graphType,'plot'))
    config.lineWidth = 2;
    config.fontSize = 12;
    config.legendFontSize = 12;
    config.labelsFontSize = 12;
    config.width = 30; % cm
    config.legX1 = 30;
    config.legX2 = 18;
elseif (strcmp(graphType,'paper')) % IEEE Model
    config.lineWidth = 1.5;
    config.fontSize = 8;
    config.legendFontSize = 8;
    config.labelsFontSize = 8;
    config.width = 9.8; % cm
    config.legX1 = 15;
    config.legX2 = 18;
elseif (strcmp(graphType,'dissertation')) % ABNT Model
    config.lineWidth = 1.5;
    config.fontSize = 9;
    config.legendFontSize = 10;
    config.labelsFontSize = 10;
    config.width = 15; % cm
    config.legX1 = 30;
    config.legX2 = 18;
else%if (strcmp(graphType,'presentation'))
    config.lineWidth = 1.5;
    config.fontSize = 9;
    config.legendFontSize = 10;
    config.labelsFontSize = 10;
    config.width = 13; % cm
    config.legX1 = 30;
    config.legX2 = 18;
end
config.height = config.width/2; % cm

% Parses input configuration
f = fieldnames(input);
for i = 1:length(f)
    config.(f{i}) = input.(f{i});
end

% File name for saving graphics
if (isfield(config, 'filename'))
    file = strcat(config.folder,config.filename,'.',config.format);
else
    % Generates filename from config.name, eliminating spaces and using
    % word with first letter in uppercase and the remaining in lowercase
    config.filename = '';
    words = strsplit(lower(config.name));
    for i = 1:length(words)
        word = words{i};
        config.filename = strcat(config.filename,upper(word(1)),word(2:end));
    end
    file = strcat(config.folder,config.filename,'.',config.format);
end

% Create new window
if (strcmp(graphType,'plot'))
    fig = figure('Name',config.name,'NumberTitle','off',...
        'WindowState','maximized');
else
    fig = figure('Name',config.name,'NumberTitle','off',...
        'Units','centimeters','Position',...
        [config.x0 config.y0 config.width config.height]);
end
% Adjust axis settings
set(gca,'Units','normalized',...
    'FontUnits','points','FontWeight','normal',...
    'FontSize',config.fontSize,'FontName',config.fontName,...
    'xcolor',config.textColor,'ycolor',config.textColor);
box on;
hold on;
grid on;
% Plot the charts
N = length(pens);
chartLegend = cell(N,1);
for i = 1:N
    penas = pens{i};
    chartLegend{i} = penas{3};
    [x,y] = stairs(penas{1},penas{2});
    lineStyle = '-';
    if (length(penas) >= 4)
        lineStyle = penas{4};
    end
    plot(x,y,lineStyle,'LineWidth',config.lineWidth);
end
% Labels
xlabel(config.xLabel,'FontUnits','points','FontWeight','normal',...
    'FontSize',config.labelsFontSize,'FontName',config.fontName,...
    'Color',config.textColor);
ylabel(config.yLabel,'FontUnits','points','FontWeight','normal',...
    'FontSize',config.labelsFontSize,'FontName',config.fontName,...
    'Color',config.textColor,'interpreter','latex');
% Title
if (strcmp(graphType,'plot'))
    title(config.name,'FontUnits','points','FontWeight','normal',...
        'FontSize',config.titleFontSize,'FontName',config.fontName,...
        'Color',config.textColor,'interpreter','latex');
end
% If the entered values are not infinite, readjust the axes
if (sum(isinf(config.xLim)) == 0)
    xlim(config.xLim);
end
if (sum(isinf(config.yLim)) == 0)
    ylim(config.yLim);
end
% Legend
leg = legend(chartLegend,'interpreter','latex',...
    'FontSize',config.legendFontSize,'FontName',config.fontName,...
    'TextColor',config.textColor,'Location',config.legPos);
leg.ItemTokenSize = [config.legX1,config.legX2];
% Changes exponent in y axis values
if (isfield(config, 'exponent'))
    ax = gca;
    ax.YAxis.Exponent = config.exponent;
end

% Save graph as image file
if (strcmp(config.format,'eps'))
    print('-depsc2',file);
elseif (strcmp(config.format,'png'))
	print('-dpng',file);
end
end
%---------------------------------------------