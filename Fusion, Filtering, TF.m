%% pentru 120

t1 = out1.simout1.Time;
t2 = out2.simout1.Time;
y1 = out1.simout1.Data;
y2 = out2.simout1.Data;

n = min(length(y1), length(y2));

t1 = t1(1:n);
t2 = t2(1:n);
y1 = y1(1:n);
y2 = y2(1:n);
t = t1(1:n);

y_med = (y1 + y2)/2;

figure;
plot(t1,y1,'b--'); hold on;
plot(t2,y2,'r--'); hold on;
plot(t,y_med,'k','LineWidth',2);

%% FTJ

%FORMULA FTJ: 1/(Tf*s+1)

% Constanta de timp a filtrului
Tf = 0.2;  

y_filtrat = zeros(size(y_med));
y_filtrat(1) = y_med(1);

% Aplicarea filtrului
for k = 2:length(y_med)

    dt = t(k) - t(k-1);

    alpha = 1 - exp(-dt/Tf);

    y_filtrat(k) = y_filtrat(k-1) + alpha * (y_med(k) - y_filtrat(k-1));
end


figure;
plot(t,y_med,'b--','LineWidth',1);
hold on;
plot(t,y_filtrat,'r','LineWidth',2);


%% pentru 170

t3 = out3.simout1.Time;
t4 = out4.simout1.Time;
y3 = out3.simout1.Data;
y4 = out4.simout1.Data;

n2 = min(length(y3), length(y4));

t3 = t3(1:n2);
t4 = t4(1:n2);
y3 = y3(1:n2);
y4 = y4(1:n2);
t = t3(1:n2);

y_med2 = (y3 + y4)/2;

figure;
plot(t3,y3,'b--'); hold on;
plot(t4,y4,'r--'); hold on;
plot(t,y_med2,'k','LineWidth',2);


%% 

% FTJ

% Constanta de timp a filtrului
Tf = 0.2;  

y_filtrat2 = zeros(size(y_med2));
y_filtrat2(1) = y_med2(1);

% Aplicarea filtrului
for k = 2:length(y_med2)

    dt = t(k) - t(k-1);

    alpha = 1 - exp(-dt/Tf);

    y_filtrat2(k) = y_filtrat2(k-1) + alpha * (y_med2(k) - y_filtrat2(k-1));
end


figure;
plot(t,y_med2,'b--','LineWidth',1);
hold on;
plot(t,y_filtrat2,'r','LineWidth',2);