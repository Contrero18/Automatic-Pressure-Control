load("measured_data.mat")

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

Tf = 0.2; % tf mai mare => nu mai urmareste bine datele

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

%% TF pentru 120
% din grafic
y_st1 = 148;
tau1 = 1.7;
tt1 = 5.6; % pentru 95% - adica la 140.6
T1 = (tt1 - tau1) / 3;
K1 = y_st1/120;

s= tf('s');
Hp120 = K1 / (T1*s + 1)
Hp120_dead = Hp120 * exp(-tau1*s) %                  1.233
                                  % exp(-1.7*s) * ---------
                                  %               1.3 s + 1


%% TF pentru 170
y_st2 = 175;
tau2 = 1.6;
tt2 = 5.8; % pentru 95% - adica la 166.25
T2 = (tt2 - tau2) / 3;
K2 = y_st2/170;

s= tf('s');
Hp170 = K2 / (T2*s + 1)
Hp170_dead = Hp170 * exp(-tau2*s)
  %                  1.029
  % exp(-1.6*s) * -----------
  %               1.4 s + 1

%% medierea celor doua tf

K_med = (K1 + K2) / 2;
T_med = (T1 + T2) / 2;
tau_med = (tau1 + tau2) / 2;

Hp_med = K_med / (T_med*s + 1)
Hp_med_dead = Hp_med * exp(-tau_med*s)
  %                  1.131
  % exp(-1.65*s) * ----------
  %                1.35 s + 1

%% coeficienti pentru PID

Ti = T_med;
Timp = 3;
Kp = Ti/(K_med*Timp);
Ki = Kp/Ti;

%% functia de sensibilitate

PI = Kp + Ki/s;

HS = 1 - (PI*Hp_med_dead)/(1 + PI*Hp_med);

figure;
bode(HS);
grid on;
title('Sensibilitate');

%% Discretizare

Ts = 0.1;

PI = Kp + Ki/s;

N_dead = round(tau_med/Ts)
PI_discret = c2d(PI, Ts, 'tustin')
Hp_discret = c2d(Hp_med, Ts, 'zoh')
