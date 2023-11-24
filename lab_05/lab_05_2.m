# ----------------------------------------- Setup inicial ------------------------------------#
pkg load control;
clear all;
close all;
clc;

# ----------------------------------------- Tempo continuo -----------------------------------#
as = [0,1;1,0];
bs = [0;1];
cs = [2,1];

aes = [0,-cs; zeros(2,1),as]
bes = [0;bs]

s1 = -0.8+i*1.92;
s2 = -0.8-i*1.92;
s3 = -2;

kes = acker(aes,bes,[s1,s2,s3])
js = -kes(1)
ks = kes(2:3)

ys = ss(aes-bes*kes, [1;0;0], [0,cs])

figure 1;
step(ys);
close;

us = ss(aes-bes*kes, [1;0;0], -kes)

# ----------------------------------------- Tempo discreto explicito --------------------------------#
ta = 0.1;
gs = ss(as,bs,cs);
gz = c2d(gs,ta);
[az,bz,cz,dz,tz] = ssdata(gz);

aez = [1, -cs; zeros(2,1), az];
bez = [0; bz];

z1 = exp(s1*ta);
z2 = exp(s2*ta);
z3 = exp(s3*ta);

kez = acker(aez,bez,[z1,z2,z3]);
jz = -kez(1)
kz = kez(2:3) # Euler explicito

yz = ss(aez-bez*kez, [1;0;0],  [0,cs], 0, ta);
uz = ss(aez-bez*kez, [1;0;0], -kez, 0, ta);

# ---------------------------------------- Tempo discreto implicito --------------------------------#

jzi = jz;
kzi = kz - jzi*cs; # Euler implicito

yzi = ss(aez-bez*kez, [1;bz*jzi],  [0,cs], 0, ta);
uzi = ss(aez-bez*kez, [1;bz*jzi], -kez, jzi, ta);

# -------------------------------------- Avaliação em tempo continuo ------------------------------#
figure 2;
subplot (2,1,1);
step(ys);
subplot(2,1,2);
step(us)
close;

# ---------------------------------- Avaliação em tempo discreto explicito -------------------------#

figure 3;
subplot (2,1,1);
step(ys, yz);
subplot(2,1,2);
step(us, uz)
close;

# ---------------------------------- Avaliação em tempo discreto implicito -------------------------#

figure 4;
subplot (2,1,1);
step(ys, yz, yzi);
subplot(2,1,2);
step(us, uz, uzi)
#close;
