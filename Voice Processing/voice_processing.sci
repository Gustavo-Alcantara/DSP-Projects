function normalized = normalize(x)
    normalix = max ( abs(min(x)), abs(max(x)) );
    normalized = x/normalix;
endfunction
function filtered = oblivion_filter(signal, alfa)
    y = zeros(1,length(signal));
    y(1) = signal(1);
    for i = 2:length(y)
        y(i) =  alfa*y(i-1) + signal(i);
    end
    filtered = y;
endfunction

function filtered =  mean_avarage(signal, M)
    y = zeros(1,length(signal));
    y(1) = signal(1);
    slice =  zeros(1,M);
    
    for i = 1:length(signal)
        for j = 1:(M-1)
            slice(j) = slice(j+1);
        end
        slice(M) = signal(i);
        if i < M then
            y(i) = sum(slice)/i;
        else
            y(i) = sum(slice)/M;
        end
    end
    filtered = y;
endfunction

function doubled = tax_double(signal)
    y = zeros(1,2*length(signal));
    for i = 1:length(signal)
        y(2*i) = signal(i);
    end
    doubled = y;
endfunction

function half = filter_odd(signal)
    y = zeros(1,ceil(length(signal)/2));
    k = 1;
    for i = 1:2:length(signal)
        y(k) = signal(1);
        k=k+1;
    end
    half = y;
endfunction

fs = 44100;
voice = wavread('source');
channels = size(voice);

mono_voice = voice(1,:);

//Filtro do esquecimento
alfa_filtered = oblivion_filter(mono_voice, 0.98);
normalized = normalize(alfa_filtered);
wavwrite(normalized, fs, 'alfa098.wav');

alfa_filtered = oblivion_filter(mono_voice, -0.98);
normalized = normalize(alfa_filtered);
wavwrite(normalized, fs, 'alfa-098.wav');

alfa_filtered = oblivion_filter(mono_voice, 0.5);
normalized = normalize(alfa_filtered);
wavwrite(normalized, fs, 'alfa05.wav');

alfa_filtered = oblivion_filter(mono_voice, -0.5);
normalized = normalize(alfa_filtered);
wavwrite(normalized, fs, 'alfa-05.wav');


//Fitro de média móvel
/*
avarage_filtered = mean_avarage(mono_voice, 50);
normalized = normalize(avarage_filtered);
wavwrite(normalized, fs, 'window50.wav');

avarage_filtered = mean_avarage(mono_voice, 100);
normalized = normalize(avarage_filtered);
wavwrite(normalized, fs, 'window100.wav');

avarage_filtered = mean_avarage(mono_voice, 1000);
normalized = normalize(avarage_filtered);
wavwrite(normalized, fs, 'window1000.wav');*/

//Correlação
sliced = mono_voice(2*fs:3*fs);
correlation = xcorr(mono_voice,sliced);

n = length(correlation);
lag = -(n-1)/2 : (n-1)/2;


plot(lag, correlation);
xlabel('Lag');
ylabel('Correlação');
title('Correlação cruzada entre entrada e trecho da entrada');


//Alteração de taxa
double_tax_signal = tax_double(mono_voice);
normalized = normalize(double_tax_signal);
wavwrite(normalized, 2*fs, 'double_tax.wav');

half_tax_signal = filter_odd(mono_voice);
normalized = normalize(half_tax_signal);
wavwrite(normalized, fs, 'half_tax.wav');



