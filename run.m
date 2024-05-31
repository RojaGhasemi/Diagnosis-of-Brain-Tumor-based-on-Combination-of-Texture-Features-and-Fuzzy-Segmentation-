function varargout = run(varargin)
% RUN MATLAB code for run.fig
%      RUN, by itself, creates a new RUN or raises the existing
%      singleton*.
%
%      H = RUN returns the handle to a new RUN or the handle to
%      the existing singleton*.
%
%      RUN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN.M with the given input arguments.
%
%      RUN('Property','Value',...) creates a new RUN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run

% Last Modified by GUIDE v2.5 12-Aug-2019 19:17:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_OpeningFcn, ...
                   'gui_OutputFcn',  @run_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before run is made visible.
function run_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run (see VARARGIN)

% Choose default command line output for run
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = run_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
clear all;
close all;
clc;

%////////////////////////////////////////////////////////////
tic
 classes=['b';'m';]; % i
 PName=['a';]; 

AllFile=dir('*.jpg');
r=1;
k1=1;
Col=1;
for i=1:2
    i;
    PerName='';
    for j=1:1
        j;
        cd ('C:\Users\DELL\Documents\MATLAB\brain tumor segmentation\train\');
        AllFile=dir('*.jpg');
        cc=1;        
        for ll=1:length(AllFile(:,1))
            TotalName(ll,1:length(AllFile(ll,1).name))=AllFile(ll,1).name;        
            if (strfind(TotalName(ll,:),classes(i,:)))
                if  (strfind(TotalName(ll,:),PName(j,:)))
                   PerName(cc,1:length(TotalName(ll,:)))=TotalName(ll,:);
                   cc=cc+1;
                end                
            end
        end
%        PerName        
     cd ('C:\Users\DELL\Documents\MATLAB\brain tumor segmentation\');
     for k=1:length(PerName(:,1))
         im=imread(strcat('C:\Users\DELL\Documents\MATLAB\brain tumor segmentation\train\',PerName(k,:)));
         rgbimage=imresize(im,[300 300]);
        rgbimage=rgb2gray(rgbimage);
 rgbimage=im2double(rgbimage);
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  DWT
 [h_LL,h_LH,h_HL,h_HH]=dwt2(rgbimage,'haar');
 
  figure;imshow(h_LL);
% figure;imshow(h_LH);
% figure;imshow(h_HL);
% figure;imshow(h_HH);


   dwtt1=cat(1,h_HL,h_LH,h_HH);
    save('dwtt1.mat','dwtt1'); 
    feature_vector_DWT = reshape (dwtt1, 1, 67500);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % zernike
    
      n = 4; m = 2;           % Define the order and the repetition of the moment

      feature_vector_Z = Zernikmoment(rgbimage,n,m);
%        figure;imshow(feature_vector_Z);
       feature_vector_Z=imresize(feature_vector_Z,[100 100]);
      feature_vector_Zernike=reshape(feature_vector_Z,1,10000);
      
 feature_vector=cat(2,feature_vector_DWT,feature_vector_Zernike);
 feature_vector=real(feature_vector);
 feature_vector_Col(Col,1:77500)=feature_vector(1,1:77500);
   save('feature_vector_Col.mat','feature_vector_Col');
   
   
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %    ACO
 x=importdata('C:\Users\DELL\Documents\MATLAB\brain tumor segmentation\feature_vector_Col.mat');
CostFunction=@(x) MyCost(x); % Modify or replace Mycost.m according to your cost funciton

Max_iteration=5; % Maximum number of iterations
noP=1; % Number of Ant
noV=77500;

ConvergenceCurves=zeros(8,Max_iteration);

%ACO with s-shaped family of transfer functions
[gBest1, gBestScore1 ,ConvergenceCurves(1,:)]=ACO(noP,Max_iteration,1,CostFunction,noV);
[gBest2, gBestScore2 ,ConvergenceCurves(2,:)]=ACO(noP,Max_iteration,2,CostFunction,noV);
[gBest3, gBestScore3 ,ConvergenceCurves(3,:)]=ACO(noP,Max_iteration,3,CostFunction,noV);
[gBest4, gBestScore4 ,ConvergenceCurves(4,:)]=ACO(noP,Max_iteration,4,CostFunction,noV);
% %ACO with v-shaped family of transfer functions
[gBest5, gBestScore5 ,ConvergenceCurves(5,:)]=ACO(noP,Max_iteration,5,CostFunction,noV);
[gBest6, gBestScore6 ,ConvergenceCurves(6,:)]=ACO(noP,Max_iteration,6,CostFunction,noV);
[gBest7, gBestScore7 ,ConvergenceCurves(7,:)]=ACO(noP,Max_iteration,7,CostFunction,noV);
[gBest8, gBestScore8 ,ConvergenceCurves(8,:)]=ACO(noP,Max_iteration,8,CostFunction,noV); 



% % % % % % % % % % % % % % % % % % % % % % % %    % sakhte matrise vijegie nahaei
    load('pBest.mat');
load('feature_vector_Col.mat');
DataSet1=feature_vector_Col;
s1=0;
for i11=1:77500
    for j11=1:1
        if pBest(j11,i11)==1
            s1=s1+1;
            DataSet(k1,s1)=DataSet1(j11,i11);

        end    
    end
end
 save('DataSet.mat','DataSet');

 [COEFF,SCORE] = princomp(zscore(DataSet)');
 SCORE=SCORE';
feature_vector_Train(Col,1:10000)=SCORE(1,1:10000);
feature_vector_Train(Col,10001)=i;
 Col=Col+1;
 

     end
    end
end


 save('feature_vector_Train.mat','feature_vector_Train'); 
 
toc
 
function pushbutton2_Callback(hObject, eventdata, handles)
[FileName, PathName] = uigetfile({'*.jpg;*.tif;*.bmp;*.gif','All Image Files'},'Select an Image');
fpath = strcat(PathName, FileName);
im = imread(fpath);
 save('im.mat','im');
axes(handles.axes1) % Select the proper axes
box on
imshow(im);

         rgbimage=imresize(im,[300 300]);
        rgbimage=rgb2gray(rgbimage);
 rgbimage=im2double(rgbimage);
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  DWT
 [h_LL,h_LH,h_HL,h_HH]=dwt2(rgbimage,'haar');
% figure;imshow(h_LH);
% figure;imshow(h_HL);
% figure;imshow(h_HH);


   dwtt1=cat(1,h_HL,h_LH,h_HH);
    save('dwtt1.mat','dwtt1'); 
    feature_vector_DWT = reshape (dwtt1, 1, 67500);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % zernike
    
      n = 4; m = 2;           % Define the order and the repetition of the moment

      feature_vector_Z = Zernikmoment(rgbimage,n,m);
%         figure;imshow(feature_vector_Z);
       feature_vector_Z=imresize(feature_vector_Z,[100 100]);
      feature_vector_Zernike=reshape(feature_vector_Z,1,10000);
      
 feature_vector=cat(2,feature_vector_DWT,feature_vector_Zernike);
 feature_vector=real(feature_vector);
 feature_vector_Col(1,1:77500)=feature_vector(1,1:77500);
   save('feature_vector_Col.mat','feature_vector_Col');
   
   
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %    ACO
 x=importdata('C:\Users\DELL\Documents\MATLAB\brain tumor segmentation\feature_vector_Col.mat');
CostFunction=@(x) MyCost(x); % Modify or replace Mycost.m according to your cost funciton

Max_iteration=5; % Maximum number of iterations
noP=1; % Number of Ant
noV=77500;

ConvergenceCurves=zeros(8,Max_iteration);

%ACO with s-shaped family of transfer functions
[gBest1, gBestScore1 ,ConvergenceCurves(1,:)]=ACO(noP,Max_iteration,1,CostFunction,noV);
[gBest2, gBestScore2 ,ConvergenceCurves(2,:)]=ACO(noP,Max_iteration,2,CostFunction,noV);
[gBest3, gBestScore3 ,ConvergenceCurves(3,:)]=ACO(noP,Max_iteration,3,CostFunction,noV);
[gBest4, gBestScore4 ,ConvergenceCurves(4,:)]=ACO(noP,Max_iteration,4,CostFunction,noV);
% %ACO with v-shaped family of transfer functions
[gBest5, gBestScore5 ,ConvergenceCurves(5,:)]=ACO(noP,Max_iteration,5,CostFunction,noV);
[gBest6, gBestScore6 ,ConvergenceCurves(6,:)]=ACO(noP,Max_iteration,6,CostFunction,noV);
[gBest7, gBestScore7 ,ConvergenceCurves(7,:)]=ACO(noP,Max_iteration,7,CostFunction,noV);
[gBest8, gBestScore8 ,ConvergenceCurves(8,:)]=ACO(noP,Max_iteration,8,CostFunction,noV); 


k1=1;
% % % % % % % % % % % % % % % % % % % % % % % %    % sakhte matrise vijegie nahaei
    load('pBest.mat');
load('feature_vector_Col.mat');
DataSet1=feature_vector_Col;
s1=0;
for i11=1:77500
    for j11=1:1
        if pBest(j11,i11)==1
            s1=s1+1;
            DataSet(k1,s1)=DataSet1(j11,i11);

        end    
    end
end
 save('DataSet.mat','DataSet');

 [COEFF,SCORE] = princomp(zscore(DataSet)');
 SCORE=SCORE';
feature_vector_Test(1,1:10000)=SCORE(1,1:10000);
feature_vector_Test(1,10001)=1;



 save('feature_vector_Test.mat','feature_vector_Test'); 
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
load('feature_vector_Train.mat');
load('feature_vector_Test.mat');
e=feature_vector_Train(1:96,1:end-1);
e1=feature_vector_Test(1,1:end-1);
T=feature_vector_Train(1:96,end);
T1=feature_vector_Test(1,end);
 model = svmtrain(e,T);
e=[];
T=[];
Class = svmclassify(model,e1);
 if (Class==1)
      set(handles.text1,'String','benign');
 end
 if (Class==2)
      set(handles.text1,'String','Malignant');
 end
len=find(Class==T1);
accnum=length(len);
accnum*100/size(e1,1)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
load('im.mat');
fim=mat2gray(im);
level=graythresh(fim);
bwfim=im2bw(fim,0.1);
[bwfim0,level0]=fcmthresh(fim,0);
[bwfim1,level1]=fcmthresh(fim,1);
figure;imshow(bwfim1);
axes(handles.axes2) % Select the proper axes
box on
imshow(bwfim1);
