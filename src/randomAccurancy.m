function result = compareRandom(ratio)
% T?o m?t s? ng?u nhi�n trong kho?ng [0, 1]
random_num = rand();

% So s�nh s? ng?u nhi�n v?i t? l? �?u v�o
if random_num > ratio
    result = 0;
else
    result = 1;
end
end