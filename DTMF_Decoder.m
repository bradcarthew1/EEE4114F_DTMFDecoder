%Reading in an audio clip
[y, Fs] = audioread('dtmfL1.wav');
%sound(y,Fs);
t = (0:1/Fs:(size(y)-1)*1/Fs);
plot(t,y);
N = 400;
D = 2;
press = [0];

for i = 0:N:(size(y))
    if ((size(y)-i) < N)
        break
    end
    y_seg = y(1+i:N+i);

    %Displaying the audio clip
    %figure();
    %plot(t,y);
    %title('DMTF Tone');
    %ylabel('Amplitude');
    %xlabel('Time [s]');

    %Setting parameters
    main=2048*2;
    mag=1024*2;

    %Filtering out non-DTMF frequencies
    y_filt_low = bandpass(y_seg, [690 950], Fs); %Extracting low-frequency components
    y_filt_high = bandpass(y_seg,[1200 1640],Fs); %Extracting high-frequency components

    %Finding the FFT and magnitude of the low-frequency spectrum
    y_fft_low = fft(y_filt_low,main);
    mag_low = abs(y_fft_low(1:mag));
    f1 = (0:length(y_fft_low)-1)*Fs/length(y_fft_low);
    %Plotting the magnitude of the low-frequency FFT
    %figure();
    %subplot(2,1,1);
    %plot(f1,abs(y_fft_low));
    %title('Magnitude of Low-Frequency Components');
    %ylabel('Magnitude');
    %xlabel('Frequency [Hz]');

    %Finding the FFT and magnitude of the high-frequency spectrum
    y_fft_high = fft(y_filt_high,main);
    mag_high = abs(y_fft_high(1:mag));
    f2 = (0:length(y_fft_high)-1)*Fs/length(y_fft_high);
    %Plotting the magnitude of the high-frequency FFT
    %subplot(2,1,2);
    %plot(f2,abs(y_fft_high));
    %title('Magnitude of High-Frequency Components');
    %ylabel('Magnitude');
    %xlabel('Frequency [Hz]');


    m = max(abs(mag_low));
    n = max(abs(mag_high));
    o = find(m==mag_low);
    p = find(n==mag_high);
    j = ((o-1)*Fs)/main;
    k = ((p-1)*Fs)/main;
    
  
    if j<=732.59 && k<=1270.91
        press = [press; 1];
    elseif j<=732.59 && k<=1404.73
        press = [press; 2];
    elseif j<=732.59 && k<=1553.04
        press = [press; 3];
    elseif j<=809.96 && k<=1270.91   
        press = [press; 4];
    elseif j<=809.96 && k<=1404.73
        press = [press; 5];
    elseif j<=809.96 && k<=1553.04
        press = [press; 6];   
    elseif j<=895.39 && k<=1270.91
        press = [press; 7];
    elseif j<=895.39 && k<=1404.73
        press = [press; 8];
    elseif j<=895.39 && k<=1553.04
        press = [press; 9];
    elseif j>895.40 && k<=1404.73 
        press = [press; 0];
    end
end
disp(press)

digits = 0;
count = 0;

for i = 1:size(press)-1
    if (press(i) == press(i+1))
        count = count + 1;
    elseif (press(i) ~= press(i+1))
        if count >= D
            digits = [digits; press(i)];
        end
        count = 0;  
    end
    if i == length(press)-1
        if count >= D
            digits = [digits; press(i)];
        end
        count = 0;
    end
end

digits = digits(2:size(digits));
for i = 1:size(digits)
    line = strcat('---> Key Pressed = ', num2str(digits(i)));
    disp(line); 
end






