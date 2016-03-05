clear;

% load data
data_ar0 = load('ar0.dat');
data_er4 = load('er4.dat');

% reshape data
data_ar0 = reshape(data_ar0, 64, 325);
data_er4 = reshape(data_er4, 64, 325);

% normalized data
data_ar0 = bsxfun(@rdivide, data_ar0, sum(data_ar0));
data_ar0(isnan(data_ar0)) = 0;
data_er4 = bsxfun(@rdivide, data_er4, sum(data_er4));
data_er4(isnan(data_er4)) = 0;

% calculating correlations
cor_ar0 = zeros(64, 125);
cor_er4 = zeros(64, 125);
for i = 1:125
    cor_ar0(:, i) = sum(data_ar0(:, 126:325) .* data_ar0(:, (126 - i + 1:325 - i + 1)), 2);
    cor_er4(:, i) = sum(data_er4(:, 126:325) .* data_er4(:, (126 - i + 1:325 - i + 1)), 2);
end

% normalize correlations
cor_ar0 = bsxfun(@rdivide, cor_ar0, max(cor_ar0, [], 2));
cor_ar0(isnan(cor_ar0)) = 0;
cor_er4 = bsxfun(@rdivide, cor_er4, max(cor_er4, [], 2));
cor_er4(isnan(cor_er4)) = 0;

% draw the figures
lag = linspace(0, 12.5, 125);

figure(1);
for i = 1:64
    semilogy(lag, exp((log(80) + (log(4000) - log(80)) / 64 * (i - 1))) + (exp(log(80) + (log(4000) - log(80)) / 64 * (i + 1)) - exp(log(80) + (log(4000) - log(80)) / 64 * (i - 1))) * cor_ar0(i,:));
    hold on;
end
axis([0 12.5 80 inf]);
title('Correlogram of /ar/');
xlabel('Lag (ms)');
ylabel('Channel Center Frequencey (Hz)');
set(gca,'XTick', [0.0 2.5 5.0 7.5 10.0 12.5], 'YTick', [80, round(exp(log(80) + (log(4000) - log(80)) / 5)),round(exp(log(80) + (log(4000) - log(80)) / 5 * 2)), round(exp(log(80) + (log(4000) - log(80)) / 5 * 3)), round(exp(log(80) + (log(4000) - log(80)) / 5 * 4)), 4000]);

figure(2);
for i = 1:64
    semilogy(lag, exp((log(80) + (log(4000) - log(80)) / 64 * (i - 1))) + (exp(log(80) + (log(4000) - log(80)) / 64 * (i + 1)) - exp(log(80) + (log(4000) - log(80)) / 64 * (i - 1))) * cor_er4(i,:));
    hold on;
end
axis([0 12.5 80 inf]);
title('Correlogram of /er/');
xlabel('Lag (ms)');
ylabel('Channel Center Frequencey (Hz)');
set(gca,'XTick', [0.0 2.5 5.0 7.5 10.0 12.5], 'YTick', [80, round(exp(log(80) + (log(4000) - log(80)) / 5)),round(exp(log(80) + (log(4000) - log(80)) / 5 * 2)), round(exp(log(80) + (log(4000) - log(80)) / 5 * 3)), round(exp(log(80) + (log(4000) - log(80)) / 5 * 4)), 4000]);

% pooling and pitch detection
pool_ar0 = sum(cor_ar0);
pool_er4 = sum(cor_er4);
h_bound = 1 / 222 * 10000;
l_bound = 1 / 80 * 10000;
[height_ar0, sample_ar0] = max(pool_ar0(floor(h_bound):ceil(l_bound)));
[height_er4, sample_er4] = max(pool_er4(floor(h_bound):ceil(l_bound)));
pitch_ar0 = round(1 / (sample_ar0 / 10000));
pitch_er4 = round(1 / (sample_er4 / 10000));
disp(['The pitch of ar0 is: ', int2str(pitch_ar0), ' Hz']);
disp(['The pitch of er4 is: ', int2str(pitch_er4), ' Hz']);
