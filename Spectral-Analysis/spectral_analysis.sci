fs = 44100;
voice = wavread("source.wav");
channels = size(voice);
N = 5*fs; 

mono_voice = voice(1,:);

figure(1);
N = 512;
n = (1:N);
signal1 = cos(2/3*%pi*n);
signal2 = cos(1/4*%pi*n);
magnitude1 = abs(fft(signal1));
magnitude2 = abs(fft(signal2));
subplot(2,1,1);
plot(magnitude1);
plot(magnitude2);
title('N=512');

N = 8192;
n = (1:N);
signal1 = cos(2/3*%pi*n);
signal2 = cos(1/4*%pi*n);
magnitude1 = abs(fft(signal1));
magnitude2 = abs(fft(signal2));
subplot(2,1,2); 
plot(magnitude1);
plot(magnitude2);
title('N=8192');


figure(2);
N = 512;
n = (1:N);
signal1 = cos(2/3*%pi*n);
signal2 = cos(1/4*%pi*n);
magnitude1 = abs(fft(signal1.*window('hn',N)));
magnitude2 = abs(fft(signal2.*window('hn',N)));
subplot(2,1,1);
plot(magnitude1);
plot(magnitude2);
title('Hanning N=512');

N = 8192;
n = (1:N);
signal1 = cos(2/3*%pi*n);
signal2 = cos(1/4*%pi*n);
magnitude1 = abs(fft(signal1.*window('hn',N)));
magnitude2 = abs(fft(signal2.*window('hn',N)));
subplot(2,1,2); 
plot(magnitude1);
plot(magnitude2);
title('Hanning N=8192');


figure(3);
N = length(mono_voice);
n = (1:N);

r = 0.97;
theta = 0.000000001;
a1 = -2*r*cos(theta);
b1 = r*r;
h1 = (r.^n) .* sin((n+1)*theta)/sin(theta);
subplot(3,1,1);
plot(h1); 
title(msprintf('Lowpass (a = %f, b = %f)', a1, b1));

r = 0.97;
theta = %pi/2;
a2 = -2*r*cos(theta);
b2 = r*r;
h2 = (r.^n) .* sin((n+1)*theta)/sin(theta);
subplot(3,1,2); 
plot(h2);
title(msprintf('Bandpass (a = %f, b = %f)', a2, b2));

r = 0.97;
theta = %pi;
a3 = -2*r*cos(theta);
b3 = r*r;
h3 = (r.^n) .* sin((n+1)*theta)/sin(theta);
subplot(3,1,3); 
plot(h3);
title(msprintf('Highpass (a = %f, b = %f)', a3, b3));


N = length(mono_voice);

mono_filtered1 = zeros(1,N);
mono_filtered2 = zeros(1,N);
mono_filtered3 = zeros(1,N);

mono_filtered1(1) = mono_voice(1);
mono_filtered2(1) = mono_voice(1);
mono_filtered3(1) = mono_voice(1);

mono_filtered1(2) = mono_voice(2) - a1 * mono_voice(1);
mono_filtered2(2) = mono_voice(2) - a2 * mono_voice(1);
mono_filtered3(2) = mono_voice(2) - a3 * mono_voice(1);

for i = 3:(N-1)
    mono_filtered1(i) =  mono_voice(i) - a1 * mono_voice(i-1) - b1*mono_voice(i-2);
    mono_filtered2(i) =  mono_voice(i) - a2 * mono_voice(i-1) - b2*mono_voice(i-2);
    mono_filtered3(i) =  mono_voice(i) - a3 * mono_voice(i-1) - b3*mono_voice(i-2);
end

figure(4);
subplot(3,1,1); 
plot(abs(fft(mono_filtered1)));
title(msprintf('Lowpass (a = %f, b = %f)', a1, b1));
subplot(3,1,2);
plot(abs(fft(mono_filtered2)));
title(msprintf('Bandpass (a = %f, b = %f)', a2, b2));
subplot(3,1,3);
plot(abs(fft(mono_filtered3)));
title(msprintf('Highpass (a = %f, b = %f)', a3, b3));

figure(5);
/*mono_filtered1 = conv(h1, mono_voice);
mono_filtered2 = conv(h2, mono_voice);
mono_filtered3 = conv(h3, mono_voice);*/

subplot(3,1,1); 
plot(abs(fft(mono_filtered1)));
title(msprintf('Lowpass (a = %f, b = %f)', a1, b1));
subplot(3,1,2);
plot(abs(fft(mono_filtered2)));
title(msprintf('Bandpass (a = %f, b = %f)', a2, b2));
subplot(3,1,3);
plot(abs(fft(mono_filtered3)));
title(msprintf('Highpass (a = %f, b = %f)', a3, b3));

figure(6);
mono_filtered1 = ifft(fft(h1).* fft(mono_voice));
mono_filtered2 = ifft(fft(h2).* fft(mono_voice));
mono_filtered3 = ifft(fft(h3).* fft(mono_voice));

subplot(3,1,1); 
plot(abs(fft(mono_filtered1)));
title(msprintf('Lowpass (a = %f, b = %f)', a1, b1));
subplot(3,1,2);
plot(abs(fft(mono_filtered2)));
title(msprintf('Bandpass (a = %f, b = %f)', a2, b2));
subplot(3,1,3);
plot(abs(fft(mono_filtered3)));
title(msprintf('Highpass (a = %f, b = %f)', a3, b3));


