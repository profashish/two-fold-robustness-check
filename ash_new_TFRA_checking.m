clc;clear all;close all;
%% Author Dr. Ashish Patwari. This program checks whether a given array is robust to single-sensor failures.
N=input("Enter the number of sensors in the desired array:")
b = [0:1:N-3 2*N-6 2*N-5]; % Enter your own array here
a = sort(b)
N = numel(a); % N denotes the number of sensors in the array
disp('<strong> Number of sensors used: </strong>')
disp(N)
%% Following part of the code is to get the difference set, DCA, and weight function. 
x = a - a.'; % This commands generates a N*N matrix. ith column of x denotes a(i)-a. For example, 1st column is 0 - {0, 2, 5, 8, 9}
d = reshape(x,[1 N*N]); % This gives the difference set as a row vector of size 1*N^2. Note that this contains repeated spatial lags as per definition.
dca = unique(sort(d)); %This gives the DCA of the linear array. The difference set is sorted and duplicates are removed.
w = histc(d,dca); % This function computes the number of times each entry occurs in d i.e., it gives the weight function

%% Plotting commands
% c=max(a)+1;
% stem(dca(c:end),w(c:end),'r','LineWidth',1.25); %This plots the weight function against spatial lags
stem(dca,w,'b','LineWidth',1.55);
title({['Weight function of two-fold SLA for $N$ = ',int2str((N))]},'FontSize',12, 'Interpreter','latex')
xlabel('$m$','Interpreter','latex','FontSize',12)
ylabel('$w(m)$','Interpreter','latex','FontSize',12)
% set(gca,'Xtick',[-max(a):10:max(a)]);
grid on
grid minor


twofold=0;
x = 2*max(a)+1;
y = length(w);
status=0;
if (y~=x)
    disp('<strong> Array cannot provide hole-free DCA </strong>')
    status=status
    return
end

    for i=2:y-1
        if (w(i)<2)
            twofold = twofold+1;
        end
    end

if (twofold~=0)
    disp('<strong> Array is hole-free but cannot provide double difference base </strong>')
    status=status+1
    return
else
    disp('<strong> Array is a DDB </strong>')
    status=2;
    
end
%% Generate failed array by failing one element at a time
count=0;
for f=2:N-1     % Fail each and every element from index 2 to N-1, one at a time (Note:MATLAB index starts from 1)
b = setdiff(a,[a(f)]);% Faulty array with single-sensor failure
%% 
N1 = numel(b);%No. of elements in the faulty array
x1 = b - b.'; % This commands generates a N*N matrix. ith column of x denotes a(i)-a. For example, 1st column is 0 - {0, 2, 5, 8, 9}
d1 = reshape(x1,[1 N1*N1]); % This gives the difference set as a row vector of size 1*N^2. Note that this contains repeated spatial lags as per definition.
dca1 = unique(sort(d1)); %This gives the DCA of the linear array. The difference set is sorted and duplicates are removed.
w1 = histc(d1,dca1); % This function computes the number of times each entry occurs in d i.e., it gives the weight function
%% If the failed array cannot generate all differences at least once, then the length(w1) becomes less as per the above HIST command

if (x~=length(w1))  %If these lengths are not same, some spatial lag is missing from the DCA.
    count=count+1;
 disp('Hidden essential sensor at'); disp(a(f))
%  disp('Failed array is'); disp(b)
end
end
%% Final verdict about the robustness

if (count~=0)
   disp('<strong> Array cannot meet F = 2/N </strong>')
   status=status+1
   return
else
   disp('<strong> Array is Robust and meets F=2/N </strong>')
   status=status+4
   return
end

