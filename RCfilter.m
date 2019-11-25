% function cascadedRCfilter(Vin,h) receives a time-series voltage sequence
% sampled with interval h, and returns the output voltage sequence produced
% by a circuit
%
% inputs:
% Vin - time-series vector representing the voltage input to a circuit
% h - scalar representing the sampling interval of the time series in
% seconds
%
% outputs:
% Vout - time-series vector representing the output voltage of a circuit

function Vout = RCfilter(Vin,h)
    Vout = FilterUnAudibleHigh(Vin,h);  
    %Vout = Vin;
end

function Vout = FilterUnAudibleHigh(Vin,h)
    [c,l] = size(Vin);
    % if (c>l)
    %     Vin = Vin'
    % end

    Vout = lowpassFilter(Vin, 160, 1*10^(-6), h, l);
end

function Vout = FilterUnAudibleLow(Vin,h)
    highpassFilter = lowpassFilter(Vin, 160, 100*10^(-6), h, 500);
    Vout = Vin-highpassFilter;
end

function noiseFreq = FindBand(Vin,h);
    % this function locates the noise span and provide the frequency cut-off value
    avg = mean(Vin);
    dev = std(Vin);
    
end

function vc_out = lowpassFilter(vin, r, c, h, k)
    % updateVoltage - takes in five arguments, vin, resistance, capacitance and time
    % step of the function, produce a output matrix that tracks the voltage of the
    % capacitor throughout k time steps
    % vin: vector of size k,
    % r: scalar
    % c: scalar
    % h: scalar
    % k: scalar
    % Syntax: vc_out = updateVoltage(vin, r, c, h, k);
    temp = zeros(k, 1);
    temp(1, 1) = 0; % assume initial state is zero
    constant = h / (r * c);
    %always assume constant v-in voltage input
    for entry = 2:k
        
        temp(entry, 1) = (1 - constant) * temp(entry - 1, 1) + (constant * vin(entry - 1));
    end
    vc_out = temp;
end