function [bomb,gun,fight,bombFs,gunFs,fightFs]=loadSound()
[bomb,bombFs] = audioread('soundbomb.wav');
bomb=bomb(1:6*bombFs);

[gun,gunFs] = audioread('MP5_gun.wav');
gun=gun(1:gunFs);

[fight,fightFs] = audioread('soundfight.wav');
fight=fight(1:20*fightFs);

% [tank,tankFs] = audioread('Tank.wav');
% fight=fight(1:20*tankFs);
