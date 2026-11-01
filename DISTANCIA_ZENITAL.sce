clc
clear
// =========================================
// DADOS DE ENTRADA DO PROBLEMA
// =========================================
labels=["Ano";"Horário_(em_horas)";"dia_do_ano"...
;"Latitude_do_local_(graus)";"Longitude_do_local_(graus)";...
"Meridiano_central_do_fuso_horário(graus)"];
[ok,ano,HL,d,latitude,longitude,meridiano]=getvalue("DADOS"...
,labels,list("vec",1,"vec",1,"vec",1,"vec",1,"vec",1,"vec",1),["2026";...
"11.167";"305"; "-24.74404";"53.75494";"45"])
global a0 a1 b1 a2 b2 a3 b3 c0 c1 d1 c2 d2 c3 d3 c4 d4 N;
N=365;
if ano==2028 then N=366; end
latitude=%pi*latitude/180; // radianos

if ~or(ano==[2026 2027 2028 2029 2030]) then
    error("Ano nao disponivel: selecione 2026 a 2030.");
end
if d<1 | d>N then
    error(msprintf("Dia invalido para %d: use 1 a %d.", ano, N));
end
if ano==2026 then
a0=0.392676407915;a1=- 22.861181844765;b1=4.257413007494;
a2=-0.386713358447; b2=0.050797120339;
a3=-0.151634591813; b3=0.089061913844;
c0=0.013858447489;c1=0.517173811896;d1=-7.320615816429;
c2=-3.533259488713;d2=-9.282311539349;
c3=-0.096140583739;d3=-0.321308347105;
c4=-0.146120412342;d4=-0.176643216158;
end
if ano==2027 then
a0 = 0.3935547185;a1 = -22.8780215145; b1 = 4.1629220619;
a2 = -0.3880750000; b2 = 0.0475458775;
a3 = -0.1525878291; b3 = 0.0870992690;
c0 = 0.0088219178;
c1 = 0.5513073105; d1 = -7.3366989486;
c2 = -3.4556492812; d2 = -9.3089855738;
c3 = -0.0916934225; d3 = -0.3224211082;
c4 = -0.1432766831; d4 = -0.1794643913;
end

if ano==2028 then
a0 = 0.329450971463;a1 = -22.893872789240;b1 = 4.258705271973;
a2 = -0.347939046261;b2 = 0.036294220388;
a3 = -0.134403077492;b3 = 0.079890938126;
c0 = 0.002076502732;c1 = 0.484283171197;d1 = -7.358634844048;
c2 = -3.544361212871;d2 = -9.233916462345;
c3 = -0.082543231244;d3 = -0.244394956460;
c4 = -0.138444263885;d4 = -0.127392647075;
end

if ano==2029 then
a0 = 0.393640639269;a1 = -22.838568008170;b1 = 4.364938935655;
a2 = -0.387055849314;b2 = 0.054946208946;
a3 = -0.150203388046;b3 = 0.091260151668;
c0 = 0.014940639269;c1 = 0.474912268140;d1 = -7.339775997905;
c2 = -3.622105483431;d2 = -9.243853353841;
c3 = -0.100914684707;d3 = -0.321044158568;
c4 = -0.148904666221;d4 = -0.174498083067;
end
if ano==2030 then
a0 = 0.393589878234;a1 = -22.855269875822;b1 = 4.270070108755;
a2 = -0.387730966618;b2 = 0.050697833358;
a3 = -0.151371083961;b3 = 0.089475405468;
c0 = 0.007648401826;c1 = 0.526374680866;d1 = -7.340555774687;
c2 = -3.547535477901;d2 = -9.275706975889;
c3 = -0.097092223745;d3 = -0.323619875641;
c4 = -0.146973431653;d4 = -0.177599165913;
end
// =========================================
// DECLINAÇÃO SOLAR 
// ==========================================
function y=DS(d)
global a0 a1 b1 a2 b2 a3 b3 c0 c1 d1 c2 d2 c3 d3 c4 d4 N;
theta=2*%pi*(d-1)/N;
y=a0+ a1*cos(1*theta) + b1*sin(1*theta)+ a2*cos(2*theta) + ...
b2*sin(2*theta)+a3*cos(3*theta) + b3*sin(3*theta)
endfunction
// =========================================
// EQUAÇÃO DO TEMPO 
// ==========================================
function y=ET(d)
global a0 a1 b1 a2 b2 a3 b3 c0 c1 d1 c2 d2 c3 d3 c4 d4 N;
theta=2*%pi*(d-1)/N;
y=c0+ c1*cos(1*theta) + d1*sin(1*theta)+ c2*cos(2*theta) + ...
d2*sin(2*theta)+c3*cos(3*theta) + d3*sin(3*theta)+ ...
c4*cos(4*theta) + d4*sin(4*theta)
endfunction
// =========================================
// CÁLCULOS DE ÂNGULOS E DECLINAÇÃO SOLAR
// =========================================
d_corrigido=d+(HL+meridiano/15)/24;// correcao para UTC (convencao original)
deslocamento=(longitude-meridiano)/15; //hora
HM=HL-deslocamento;
HV=HM+ET(d_corrigido)/60-12;
HV=(15/180)*%pi*HV; // radianos
declinacao1=DS(d_corrigido); // graus
declinacao=%pi*declinacao1/180; // radianos
a=sin(latitude)*sin(declinacao);
b=cos(latitude)*cos(declinacao)*cos(HV)
zen=acos(a+b); // distância zenital em radianos
sombra=tan(zen);
zen=180*zen/(%pi); // distância zenital em graus
ocaso=(180/%pi)*acos(-tan(latitude)*tan(declinacao));
azimute=(180/%pi)*acos((1/cos(latitude))*sin(declinacao));
// =========================================
// RESULTADOS EM JANELA COM CAMPOS ALINHADOS
// =========================================
rotulos_resultados = ["Declinação solar (graus)"; ...
 "Equacao do Tempo (min)"; ...
 "Distancia zenital (graus)"; ...
 "Duracao do dia (horas)"; ...
 "Azimute do nascer do Sol (graus)"; ...
 "metros de sombra por metro de bastão (m/m)"];

valores_resultados = [msprintf("%.2f", declinacao1);...
 msprintf("%.4f", ET(d_corrigido)); ...
 msprintf("%.3f", zen); ...
 msprintf("%.3f", 2*(ocaso/15)); ...
 msprintf("%.3f", azimute); ...
 msprintf("%.3f", sombra)];

titulo1 = msprintf("RESULTADOS SOLARES - %d", ano);
titulo2 = msprintf(" | Dia %d | Hora %.3f h", d, HL);
titulo_resultados = titulo1 + titulo2; 
x_mdialog(titulo_resultados, rotulos_resultados,...
 valores_resultados);
