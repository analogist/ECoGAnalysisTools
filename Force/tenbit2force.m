function [ pressure ] = tenbit2force( tenbitadc )
%TENBITTOFORCE Summary of this function goes here
%   Detailed explanation goes here
    Pmin = 15*0.1;
    Pmax = 15*0.9;
    Vsupply = 5;
    
    voltage = double(tenbitadc)*Vsupply/(2^10-1);
    pressure = (voltage - 0.1*Vsupply)/0.8/Vsupply*(Pmax - Pmin);
end

