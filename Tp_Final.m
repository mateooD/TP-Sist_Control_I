% Trabajo_Integrador_SistControl_I
% Obtencion de funcion de transferencia
% Variables
% R=Resistencia Térmica
% C=Capacitancia Térmica
% m=Masa de aire contenida en el horno
% c=Calor especifico del aire a T° Ambiente

% Teniendo de referencia el horno Top100/R el cuales tiene las siguientes
% caracteristicas: 
% Ø=d=480mm,h=570mm ,V=100

format shortEng

R=13.85; 
h=0.57;
d=0.48;
r=d/2;


v=pi*(r^2)*h; %Volumen de un cilindro
m=1.225*v; %DensidadAire*Volumen
c=1015;

C=m*c;

s=tf('s');
G=(R*C*s)+1; 
Gaux=R/G;

disp('Funcion de transferencia lazo abierto');

FTLA=minreal(Gaux) 

disp('Funcion de transferencia lazo cerrado');

FTLC=minreal(feedback(Gaux,1))


%Respuesta transitoria , Sistema primer orden
step(FTLC)
title('Respuesta al escalon de nuestro sistema')

%Error estado estable
disp('Calculo error estado estable');
Kp=evalfr(FTLA,0)
ess_e=1/(1+Kp)
step(feedback(FTLA,1));

%Lugar de raices
%rlocus(FTLA);

%Compensador PI - polos dominantes
pole(FTLA)
pzmap(FTLA)
ti=(-1/pole(FTLA)) %Ajustamos nuestro tiempo de integracion de tal manera
                   %que se cancele el polo dominante


controladorI=(s+(1/ti))/s  %Formula generica controlador proporcional
rlocus(FTLA)
%ts=4tau
%tau=1/wn
%Entonces -> ts=4/wn

%Supongo 8hs ts que es criterio de diseño
ts=28800
%psita=1 , se verifica con lugar de raices
wn=4/ts

%En el lugar de raices, se busca la semicircunferencia para obtener
%coordenada en el plano complejo

% Punto de diseño ->wn
% modulo |PI*FTLA|= 1/K
 
S1=1.3889e-04; %obtenido por visualizar el lugar de raices en wn
invK=abs(0.007797/S1)
Kp=1/invK  %obteniendo asi el valor de la constante proporcional

FTLAc= minreal(Kp*controladorI*FTLA)

FTLCc= minreal(feedback(FTLAc,1))

%Verificacion de datos obtenidos
step(FTLCc)

%Error estado estable post diseño controlador
kpc=evalfr(FTLAc,0)
epc=1/(1+kpc)
