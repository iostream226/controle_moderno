% Formula de ackerman ou algoritimo de place

% G1(s) =     1           G2(s) =  s + 2         G3(s) = s - 2
%         --------                -------               -------
%         s^2 + s                 s^2 - 1               s^2 - 1

%| x1' | = | 0 1 | * | x1 | + | 0 | * u
%| x2' |   | 1 0 |   | x2 |   | 1 |

%y = [ 2 1 | x1 |]
%          | x2 |

%x1' = x2
%x2' = x1 + u
%y = 2*x1 + x2

pkg load control;
clear all;
close all;
clc;

% Representação do mapa de estados
a1= [0,1;0,-1];
a2= [0,1;1,0];

eig(a1);
eig(a2);

b = [0;1];

c1 = [1,0];
c2 = [2,1];
c3 = [-2,1];

g1 = ss(a1, b, c1);
g2 = ss(a2, b, c2);
g3 = ss(a2, b, c3);

% polos encontrados a partir das especificações de OV% = 27% e Ta = 5segundos
s1 = -0.8 + i*1.92;
s1 = s1/10; % Diminuido a frequencia me garante um comportamento mais proximo do desejado
s2 = -0.8 - i*1.92;
s2 = s2/10; % Diminuido a frequencia me garante um comportamento mais proximo do desejado

% Aplicando os fatores que desejo nas funções G1 e G2

ts = tf(s1*s2,[1,-s1-s2,s1*s2]); % Sistema que desejo alcançar dada as especificações
k1 = acker(a1,b,[s1,s2]); % Correção para G1
k2 = acker(a2,b,[s1,s2]); % Correção para G2 e para G3

% sistema 01

f1 = -1 / ( c1*inv(a1-b*k1)*b); % ganho feedforward

t1 = ss(a1-b*k1,b*f1,c1); % retroação de estados e o ganho de ação direta
figure;
step(t1,ts);
tf(t1);

% sistema 02

f2 = -1 / ( c2*inv(a2-b*k2)*b); % ganho feedforward

t2 = ss(a2-b*k2,b*f2,c2); % retroação de estados e o ganho de ação direta
figure;
step(t2,ts);
tf(t2);

% o importante é percerber que ao comparar o sistema 1 com o sistema 2 temos
% um deslocamento do zero da função uma vez que o denominador (polo) são
% iguais;

% sistema 03

f3 = -1 / ( c3*inv(a2-b*k2)*b); % ganho feedforward

t3 = ss(a2-b*k2,b*f3,c3); % retroação de estados e o ganho de ação direta
figure;
step(t3,ts);
tf(t3);
