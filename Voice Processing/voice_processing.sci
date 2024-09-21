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
avarage_filtered = mean_avarage(mono_voice, 50);
normalized = normalize(avarage_filtered);
wavwrite(normalized, fs, 'window50.wav');

avarage_filtered = mean_avarage(mono_voice, 100);
normalized = normalize(avarage_filtered);
wavwrite(normalized, fs, 'window100.wav');

avarage_filtered = mean_avarage(mono_voice, 1000);
normalized = normalize(avarage_filtered);
wavwrite(normalized, fs, 'window1000.wav');

