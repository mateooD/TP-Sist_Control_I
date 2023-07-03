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


R=13.85;
h=0.57;
d=0.48;
r=d/2;


v=pi*(r^2)*h %Volumen de un cilindro
m=1.225*v; %DensidadAire*Volumen
C=m*1015



s=tf('s');
G=(R*C*s)+1;
Gaux=R/G

disp('Funcion de transferencia lazo abierto');

FTLA=Gaux

disp('Funcion de transferencia lazo cerrado');

FTLC=minreal(feedback(Gaux,1))


%Respuesta transitoria
step(FTLC)
title('Respuesta al escalon de nuestro sistema')

%Error estado estable
disp('Calculo error estado estable');
Kp=evalfr(FTLA,0)
ess_e=1/(1+Kp)
step(feedback(FTLA,1));

%Lugar de raices
rlocus(FTLA);

