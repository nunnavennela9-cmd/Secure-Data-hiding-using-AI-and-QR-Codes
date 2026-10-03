clc;
clear;
close all;

%% 1. Read Input Images
cover = imread('input.png');
if size(cover, 3) == 3
    gray = uint8(0.299*double(cover(:,:,1)) + 0.587*double(cover(:,:,2)) + 0.114*double(cover(:,:,3)));
else
    gray = cover;
end
[m, n] = size(gray);

qr = imread('qr.png');
if size(qr, 3) == 3
    qr = uint8(0.299*double(qr(:,:,1)) + 0.587*double(qr(:,:,2)) + 0.114*double(qr(:,:,3)));
end

QR_SIZE = [80, 80];
qr_resized = imresize(qr, QR_SIZE);
qr_bin = qr_resized > 128;
qr_data = uint8(qr_bin(:));
data_len = length(qr_data);

%% 2. Edge Detection (LSB Zeroed for Extraction Stability)
gray_base = bitand(gray, 254); 

sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];

edge_img = zeros(m, n);
for i = 2:m-1
    for j = 2:n-1
        gx = sum(sum(double(gray_base(i-1:i+1, j-1:j+1)) .* sobel_x));
        gy = sum(sum(double(gray_base(i-1:i+1, j-1:j+1)) .* sobel_y));
        edge_img(i,j) = sqrt(gx^2 + gy^2);
    end
end
edge_mask = edge_img > 20;

if sum(edge_mask(:)) < data_len
    error('Cover image does not have enough edge pixels to hold the QR code!');
end

%% 3. Embed QR into Cover Image
stego = gray;
k = 1;

for i = 1:m
    for j = 1:n
        if edge_mask(i,j) && k <= data_len
            stego(i,j) = bitset(stego(i,j), 1, qr_data(k));
            k = k + 1;
        end
    end
end

imwrite(stego, 'stego_qr.png');
disp('✔ QR Embedded Successfully into stego_qr.png');

%% 4. Extract QR from Stego Image
stego_in = imread('stego_qr.png');
stego_base = bitand(stego_in, 254);
edge_extract = zeros(m, n);

for i = 2:m-1
    for j = 2:n-1
        gx = sum(sum(double(stego_base(i-1:i+1, j-1:j+1)) .* sobel_x));
        gy = sum(sum(double(stego_base(i-1:i+1, j-1:j+1)) .* sobel_y));
        edge_extract(i,j) = sqrt(gx^2 + gy^2);
    end
end
extract_mask = edge_extract > 20;

extract_bits = zeros(data_len, 1);
k = 1;

for i = 1:m
    for j = 1:n
        if extract_mask(i,j) && k <= data_len
            extract_bits(k) = bitget(stego_in(i,j), 1);
            k = k + 1;
        end
    end
end

qr_recovered = reshape(extract_bits, QR_SIZE);
qr_recovered_img = uint8(qr_recovered * 255);

imwrite(qr_recovered_img, 'recovered_qr.png');
disp('✔ Recovered QR saved as recovered_qr.png');