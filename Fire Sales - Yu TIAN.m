% Inefficient Financial Markets
% Fire Sales
% 
% March 31st, 2015
% 

fs = readtable('fs.csv'); % where fs.csv is the data for stata saved in a csv file

% fire sale event : a stock quarter in which MFFLOW falls below 10 % value
% of the full sample.
fs.mfflow_num = str2double(fs.mfflow);
fs.prc_num = str2double(fs.prc);
fs.ret_num = str2double(fs.ret);
fs.shrout_num = str2double(fs.shrout);
fs.mv_num = str2double(fs.mv);

q10 = quantile(fs.mfflow_num(~isnan(fs.mfflow_num)), .10);
fs.isFS = fs.mfflow_num < q10;

% For each firm quarter that corresponds to a fire sale
%   Computefor the first month of the quarter (m) the abnormal return of
%   the fund in each month from m-12 to m+26
%       Note: abnormal return = return of fund - return of eq weighted CRSP index. 
fs.abret = fs.ret_num - fs.crsp_ew;

% id start of quarter.
% merge first date by mfflow triple. 

tmp = nan(sum(fs.isFS)/3,39);
j = 1;
for i = 1:size(fs,1)
    if  (fs.isFS(i) == 1 && fs.mfflow_num(i) ~= fs.mfflow_num(i-1))
        if fs.permno(i) == fs.permno(i-12)
            k1 = 12;
        else
            temp = find(fs.permno(i-12:i), fs.permno(i));
            k1 = 13-temp(1);
        end
        if i+26<= size(fs,1)
            if fs.permno(i) == fs.permno(i+26)
                k2 = 26;
            else
                temp = find(fs.permno(i:i+26),fs.permno(i));
                k2 = temp(end)-1;
            end
        else
            if fs.permno(i) == fs.permno(end)
                k2 = size(fs,1)-i;
            else
                temp = find(fs.permno(i:end),fs.permno(i));
                k2 = temp(end)-1;
            end
        end            
        tmp(j,1:k1+k2+1) = fs.abret(i-k1:i+k2)';
        j=j+1;
    end
end

% compute average over all the fire sale events of the abnormal return for
% each k = -12,...,26

for i = 1:39
    avgAb(i) = mean(tmp(~isnan(tmp(:,i)),i));
end

% plot the Cumulative abnormal returns from 12 months before the fire sale
% quarter to 24 months after. 
% CAAR(h) = sum_{k=-12}^h  r(k)

for i = 1:39
    caar(i) = sum(avgAb(1:i));
end

figure
plot(-12:26, caar)
title('CAAR of fire sale quarters')
xlim([-12,26])
xlabel('Month')
ylabel('CAAR')
grid on