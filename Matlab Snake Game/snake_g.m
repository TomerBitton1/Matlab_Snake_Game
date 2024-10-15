% MATLAB Snake game 
function varargout = snake_g(varargin)
% Initialization code (default)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @snake_g_OpeningFcn, ...
                   'gui_OutputFcn',  @snake_g_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code


% Executes just before snake_g is made visible
function snake_g_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for snake_g
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.axes1);
axis('off');

% Setting the highest score
global highestScore;
global score_keeper;
if score_keeper >= 1 
    highestScore = score_keeper;
else
    highestScore = 0;
end
set(handles.highest_score, 'String', num2str(highestScore));


function varargout = snake_g_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
% Start the first game without pressing any button
start_game_Callback(hObject, eventdata, handles);

% Right - 1
% Up - 2
% Left - 3
% Down - 4

% Executes on button press in up
function up_Callback(hObject, eventdata, handles)
global direction;
% If the current direction is not down, the direction is updated to up
if ~(direction==4)
    direction=2;
end

% Executes on button press in right
function right_Callback(hObject, eventdata, handles)
global direction ;
if ~(direction==3)
    direction=1; 
end

% Executes on button press in down
function down_Callback(hObject, eventdata, handles)
global direction ;
if ~(direction==2)
    direction=4;  
end

% Executes on button press in left
function left_Callback(hObject, eventdata, handles)
global direction;
if ~(direction==1)
    direction=3;   
end


% Executes on button press in start_game
function start_game_Callback(hObject, eventdata, handles)
% Create global variables
global mata matb matc;
global direction; direction = 3;  % Default movement is Left
global points; points = 0;
global highestScore;
global score_keeper;
speed = 0.06; % Snake speed

% Updated GUI element with the value of highestScore and points
set(handles.highest_score, 'String', num2str(highestScore));
set(handles.score, 'String', points);

% Snake coordinates
locx = [50 50 50 50 50 50 50 50 50];
locy = [60 61 62 63 64 65 66 67 68];

% Creating game board with black background
mata = zeros(100, 100);
matb = zeros(100, 100);
matc = zeros(100, 100);

% Update the graphical representation of the snake
update_snake(locx, locy);

% Set the left and right sides of the square with yellow boundary
mata(:, [1, end]) = 255;
matb(:, [1, end]) = 255;
matc(:, [1, end]) = 0;

% Set the top and bottom sides of the square with yellow boundary
mata([1, end], :) = 255;
matb([1, end], :) = 255;
matc([1, end], :) = 0;
    
while(1)
	% Generates a random point ("apple")
	point_x = randi([2, size(mata, 1) - 1], 1);
	point_y = randi([2, size(mata, 2) - 1], 1);
	% Check if the random point is on our snake, if so generate a new one
	if sum(locx==point_x & locy==point_y)==0
	break;
	end
end
    
% Make the random point visible with white color
mata(point_x, point_y) = 255;
matb(point_x, point_y) = 255;
matc(point_x, point_y) = 255;

% Display the initial state of the game
imshow(uint8(cat(3, mata, matb, matc)));
    
% Modified game loop
while ishandle(hObject)  % Check if the game window is open (the game is running)
	    imshow(uint8(cat(3, mata, matb, matc)));
		pause(speed);
		len = length(locx);
		% Clear the previous position of the snake from the image
		for i = 1:len
			mata(locx(i), locy(i)) = 0;
			matb(locx(i), locy(i)) = 0;
			matc(locx(i), locy(i)) = 0;
		end
		
		% Check if the snake ate the apple
		if sum((locx(1) == point_x) & (locy(1) == point_y)) == 1
			locx(2:len+1) = locx(1:len);
			locy(2:len+1) = locy(1:len);
			
			% Generate a new apple position
			while(1) 
				point_x = randi([2, size(mata, 1) - 1], 1);
				point_y = randi([2, size(mata, 2) - 1], 1);
				% Check if the apple is on our boundaries
				if sum(locx==point_x & locy==point_y)==0
					break;
				end
			end
			
			% Make the new apple visible with white color
			mata(point_x, point_y) = 255;
			matb(point_x, point_y) = 255;
			matc(point_x, point_y) = 255;
			
			points = points + 1;
			set(handles.score, 'String', num2str(points));
			% Increase speed as points increase
			speed = max(0.02, speed - 0.02); 
			
			% Check and update the highest score
			if points > highestScore
				highestScore = points;
				score_keeper = points;
				set(handles.highest_score, 'String', num2str(highestScore));
			end	
			
		else
			% Move the snake forward
			locx(2:len) = locx(1:len-1);
			locy(2:len) = locy(1:len-1);
		end
		
		% Update snake's direction
		if direction == 1  % Moving Right
			% Checks if the snake's head has hit the board boundaries
			if locy(1) == 100
				gameOver();  
				break;
			else
				% If not, continue moving right
				locy(1) = locy(1) + 1; 
			end

			% Check if the snake collides with itself after moving
			if sum((locx(2:end) == locx(1)) & (locy(2:end) == locy(1)))
				gameOver(); 
				break;
			end

		elseif direction == 2  % Moving Up
			if locx(1)==1
				gameOver();  
				break;
			else
				locx(1) = locx(1) - 1; 
			end

			% Check if the snake collides with itself after moving
			if sum((locx(2:end) == locx(1)) & (locy(2:end) == locy(1)))
				gameOver();  
				break;
			end

		elseif direction == 3  % Moving Left
			if locy(1)==1
				gameOver();  
				break;
			else
				locy(1) = locy(1) - 1; 
			end

			% Check if the snake collides with itself after moving
			if sum((locx(2:end) == locx(1)) & (locy(2:end) == locy(1)))
				gameOver();  
				break;
			end

		elseif direction == 4  % Moving Down
			if locx(1)==100
				gameOver();  
				break;
			else
				locx(1) = locx(1) + 1; 
			end

			% Check if the snake collides with itself after moving
			if sum((locx(2:end) == locx(1)) & (locy(2:end) == locy(1)))
				gameOver();  
				break;
			end
		end
		% Update the snake's position on the board
		update_snake(locx, locy);
end

% Function to handle game over
function gameOver()
mata(:,:) = 255;
matb(:,:) = 255;
matc(:,:) = 0;
imshow(uint8(cat(3, mata, matb, matc)));
f = figure('Position', [500, 500, 300, 150], 'MenuBar', 'none', 'NumberTitle', 'off', 'Name', 'Game Over');
movegui(f, 'center');

uicontrol('Style', 'text', 'String', 'GAME OVER', ...
		  'Position', [20, 70, 260, 40], ...
		  'FontSize', 14, 'HorizontalAlignment', 'center');

uicontrol('Style', 'pushbutton', 'String', 'OK', ...
		  'Position', [100, 20, 100, 30], ...
		  'Callback', 'close(gcf)');
uiwait(f);


% Executes on button press in end_game
function end_game_Callback(hObject, eventdata, handles)
global highestScore;
global score_keeper;
highestScore=0;
score_keeper=0;
close; 


function update_snake(locx,locy)
global mata matb matc
% Create the red color for snake head
mata(locx(1),locy(1))=255;
matb(locx(1),locy(1))=0;
matc(locx(1),locy(1))=0;

for i=2:length(locx)
	% Create the green color for snake body
	mata(locx(i),locy(i))=0;
	matb(locx(i),locy(i))=255;
	matc(locy(i),locy(i))=0;
end


% Executes on key press with focus on figure1 and none of its controls
function figure1_KeyPressFcn(hObject, eventdata, handles)
global direction ;
% Determine which arrow key was pressed 
switch(eventdata.Key)
% Update the direction variable accordingly to control the movement direction in a game
    case 'uparrow'
        if ~(direction==4)
            direction=2;
        end
    case 'downarrow'
        if ~(direction==2)
            direction=4;
        end
    case 'rightarrow'
        if ~(direction==3)
            direction=1;  
        end
    case 'leftarrow'
        if ~(direction==1)
            direction=3;
        end    
    otherwise % If a different button is pressed the direction will not change
        direction=direction; 
end