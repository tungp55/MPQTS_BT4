function result = compareRandom(ratio)
% T?o m?t s? ng?u nhiên trong kho?ng [0, 1]
random_num = rand();

% So sánh s? ng?u nhiên v?i t? l? ğ?u vào
if random_num > ratio
    result = 0;
else
    result = 1;
end
end