% LineConvert: Given characteristics of one or two lines or line segments, 
%              compute other characteristics.
%
%     A3 = LineConvert(code,A1,{A2})
%         code = conversion code.
%         A1 = first input argument.
%         A2 = second input argument, if required.
%         -----------------------------------------
%         A3 = first output argument.
%         A4 = second output argument, if required.
%
%         Arguments may be one of the following, for n objects:
%             P =     [n x 2] matrix of point coordinates.
%             L =     [n x 3] matrix of line coordinates.
%             theta = [n x 1] vector of counterclockwise angles (radians).
%             B0 =    [n x 1] vector of y-intercepts of lines.
%             B1 =    [n x 1] vector of slopes of lines.
%             D =     [n x 1] vector of distances.
%
%         Conversion codes:
%           Code    Input           Output
%           ----    -----        -------------------------------------------------------------
%             1     P1,P2        L: line coordinates.
%             2     P1,P2        L: line coordinates of perpendicular bisector.
%             3     P,B1         L: line coordinates.
%             4     P,theta      L: line coordinates of line counterclockwise from horizontal.  
%             5     P,L          L: parallel line thru point.
%             6     P,L          L: perpendicular line thru point.
%             7     P,L          D: distance of point from line.
%             8     P,L          P: projection of point onto line.
%             9     P,L          P: reflection of point about line.
%            10     L            B0,B1: intercept and slope.
%            11     L1,L2        P: point of intersection.
%            12     L1,L2        theta: smaller angle between L1 and L2.
%            13     L1,theta     L: line rotated theta radians from L1.
%

% RE Strauss, 8/10/04

function [A3,A4] = LineConvert(code,A1,A2)
  if (nargin < 2) A1 = []; end;
  if (nargin < 3) A2 = []; end;
  
  ncodes = 13;
  
  a11 = [];                               % Codes requiring 1-parameter object in A1 position
  a12 = [1:9];                            % Codes requiring 2-parameter object in A1 position
  a13 = [10:13];                          % Codes requiring 3-parameter object in A1 position
  
  a21 = [3:4,13];                         % Codes requiring 1-parameter object in A2 position
  a22 = [1:2];                            % Codes requiring 2-parameter object in A2 position
  a23 = [5:9,11:12];                      % Codes requiring 3-parameter object in A2 position
  
  a31 = [7,10,12];                        % Codes producing 1-parameter object in A3 position
  a32 = [8:9,11];                         % Codes producing 2-parameter object in A3 position
  a33 = [1:6,13];                         % Codes producing 3-parameter object in A3 position
  
  a41 = [10];                             % Codes producing 1-parameter object in A4 position
  a42 = [];                               % Codes producing 2-parameter object in A4 position
  a43 = [];                               % Codes producing 3-parameter object in A4 position

  if (isempty(code))
    error('  LineConvert: conversion code required');
  end;

  [r1,c1] = size(A1);
  [r2,c2] = size(A2);
  N = r1;
  
  err = 0;
  if (isempty(A1))
      err = 1;
  end;
  if (isin(code,a11) & c1~=1) err=1; end;
  if (isin(code,a12) & c1~=2) err=1; end;
  if (isin(code,a13) & c1~=3) err=1; end;
  if (isin(code,a21) & c2~=1) err=1; end;
  if (isin(code,a22) & c2~=2) err=1; end;
  if (isin(code,a23) & c2~=3) err=1; end;
  if (~isempty(A2))
    if (r1~=r2)
      err = 1;
    end;
  end;
  if (err)
    error('  LineConvert: invalid number or dimensions of input argument(s).');
  end;

  A3 = [];
  A4 = [];
  
  if (isin(code,a31)) A3 = zeros(N,1); end;
  if (isin(code,a32)) A3 = zeros(N,2); end;
  if (isin(code,a33)) A3 = zeros(N,3); end;
  if (isin(code,a41)) A4 = zeros(N,1); end;
  if (isin(code,a42)) A4 = zeros(N,2); end;
  if (isin(code,a43)) A4 = zeros(N,3); end;
  
  for i = 1:N
    switch(int2str(code))
      case '1',         %  P1,P2        L: line coordinates
        p1 = A1(i,1); p2 = A1(i,2);
        q1 = A2(i,1); q2 = A2(i,2);
        L = [p2-q2, q1-p1, p1*q2-q1*p2];
        A3(i,:) = L;
        
      case '2',         %  P1,P2        L: line coordinates of perpendicular bisector of line segment.
        p1 = A1(i,1); p2 = A1(i,2);
        q1 = A2(i,1); q2 = A2(i,2);
        L = [q1-p1, q2-p2, 0.5*(q1*q1 + q2*q2 + p1*p1 + p2*p2)];
        A3(i,:) = L;
        
      case '3',         %  P,B1         L: line coordinates
        p1 = A1(i,1); p2 = A1(i,2);
        b1 = A2(i);
        q1 = p1+1; q2 = p2+b1;
        L = [p2-q2, q1-p1, p1*q2-q1*p2];
        A3(i,:) = L;
      
      case '4',         %  P,theta      L: line coordinates
        p1 = A1(i,1); p2 = A1(i,2);
        theta = A2(i);
        q1 = p1+1; q2 = p2;
        l1 = p2-q2; l2 = q1-p1; l3 = p1*q2-q1*p2;
        L = [l1*cos(theta)-l2*sin(theta), -l1*sin(theta)+l2*cos(theta), 0];
        [l1,l2,l3] = extrcols(L);
        L = [l1, l2, -(p1*l1+p2*l2)];
        A3(i,:) = L;
      
      case '5',         %  P,L          L: parallel line thru point
        p1 = A1(i,1); p2 = A1(i,2);
        l1 = A2(i,1); l2 = A2(i,2); l3 = A2(i,3);
        L = [l1, l2, -(p1*l1+p2*l2)];
        A3(i,:) = L;
      
      case '6',         %  P,L          L: perpendicular line thru point
        p1 = A1(i,1); p2 = A1(i,2);
        l1 = A2(i,1); l2 = A2(i,2); l3 = A2(i,3);
        L = [-l2, l1, (l2*p1-l1*p2)];
        A3(i,:) = L;

      case '7',         %  P,L          D: distance of point from line
        p1 = A1(i,1); p2 = A1(i,2);
        l1 = A2(i,1); l2 = A2(i,2); l3 = A2(i,3);
        DL= sqrt(l1*l1 + l2*l2);
        DLP = (p1*l1 + p2*l2 + l3)/DL;
        A3(i,:) = DLP;
        
      case '8',         %  P,L          P: projection of point onto line
        p1 = A1(i,1); p2 = A1(i,2);
        l1 = A2(i,1); l2 = A2(i,2); l3 = A2(i,3);
        DL= sqrt(l1*l1 + l2*l2);
        DLP = (p1*l1 + p2*l2 + l3)/DL;
        D = DLP/DL^2;
        P = [p1-l1*D, p2-l2*D];
        A3(i,:) = P;
      
      case '9',         %  P,L          P: reflection of point about line
        p1 = A1(i,1); p2 = A1(i,2);
        l1 = A2(i,1); l2 = A2(i,2); l3 = A2(i,3);
        DL= sqrt(l1*l1 + l2*l2);
        DLP = (p1*l1 + p2*l2 + l3)/DL;
        D = DLP/DL^2;
        P = [p1-2*l1*D, p2-2*l2*D];
        A3(i,:) = P;
      
      case '10',        %  L            B0,B1: slope and intercept
        l1 = A1(i,1); l2 = A1(i,2); l3 = A1(i,3);
        B1 = -l1/l2;
        B0 = -l3/l2;
        A3(i) = B0;
        A4(i) = B1;
      
      case '11',        % L1,L2        P: point of intersection
        l1 = A1(i,1); l2 = A1(i,2); l3 = A1(i,3);
        m1 = A2(i,1); m2 = A2(i,2); m3 = A2(i,3);
        DLM = l1*m2-l2*m1;
        if (abs(DLM) > eps)
          P = [(l2*m3-m2*l3)/DLM, (l3*m1-l1*m3)/DLM];
        else
          P = NaN;
        end;
        A3(i,:) = P;
      
      case '12',        % L1,L2        theta: smaller angle between L1 and L2
        l1 = A1(i,1); l2 = A1(i,2); l3 = A1(i,3);
        m1 = A2(i,1); m2 = A2(i,2); m3 = A2(i,3);
        DL = sqrt(l1*l1 + l2*l2);
        DM = sqrt(m1*m1 + m2*m2);
        costheta = (l1*m1 + l2*m2)/(DL*DM);
        A3(i) = min([acos(costheta),pi-acos(costheta)]);
      
      case '13',        % L1,theta     L: line rotated theta radians from L1
        l1 = A1(i,1); l2 = A1(i,2); l3 = A1(i,3);
        theta = A2(i);
        L = [l1*cos(theta)-l2*sin(theta), -l1*sin(theta)+l2*cos(theta), 0];
        A3(i,:) = L;
        
      otherwise,
        error('  LineConvert: invalid conversion code');
    end;
  end;
  
  return;
  

    