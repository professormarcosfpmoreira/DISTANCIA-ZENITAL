clc
clear
// =========================================
// DADOS DE ENTRADA DO PROBLEMA
// =========================================
labels=["Número de harmônicos"];
[ok,k]=getvalue("DADOS"...
,labels,list("vec",1),["1"])
// =========================================
// DADOS EXPERIMENTAIS
// ==========================================
y_exp = [ ];
N = length(y_exp);
dia = (1:N)';
// ========================================================
// Matriz do modelo: a0 + soma[ak*cos(k*w*d)+bk*sin(k*w*d)]
// ========================================================
theta = 2*%pi*(dia-1)/N;
X = ones(N, 2*k+1);
for i = 1:k
    X(:,2*i) = cos(i*theta);
    X(:,2*i+1) = sin(i*theta);
end

// =========================================
// MÉTODO DOS MÍNIMOS QUADRADOS
// ==========================================
coef = inv(X'*X)*(X'*ET_exp);
y_cal = X*coef;
res = y_exp - y_cal;
SSE = sum(res.^2);
SST = sum((y_exp - mean(y_exp)).^2);
r = correl(y_exp, y_cal);
R2 = r^2;
RMSE = sqrt(mean(res.^2));
erro_max = max(abs(res));
// =========================================
// IMPRESSÃO DOS RESULTADOS NO CONSOLE
// ==========================================
mprintf("\nAJUSTE DE FOURIER - 2027\n");
mprintf("Harmonicos: %d\n",k);
mprintf("a0 = %.10f\n",coef(1));
for i = 1:k
mprintf("a%d = %.10f; b%d = %.10f\n",i,coef(2*i),i,coef(2*i+1));
end
mprintf("R2 = %.10f\n",R2);
mprintf("RMSE = %.8f min\n",RMSE);
mprintf("Erro maximo absoluto = %.8f min\n",erro_max);

// =========================================
// GRAFICOS NA MESMA JANELA
// =========================================
 scf(0);
 clf();
// =========================================
// GRÁFICO DE COMPARAÇÃO EXP E CALC
// ==========================================
 subplot(2,1,1);
 plot(dia,y_exp,"r+");
 plot(dia,y_cal,"b-");
legend(["AstroPixels 2027"; ...
msprintf("Ajuste para %d harmônicos", k)], 2);
 xgrid();
 xtitle(" ", ...
        "Dia do ano","Variável y");
// =========================================
// GRÁFICO PARA AVALIAR OS RESÍDUOS
// ==========================================
 subplot(2,1,2);
 plot(dia,res*60,"k-");
 xgrid();
xtitle(msprintf("Resíduos para %d harmônicos", k), ...
       "Dia do ano", "Resíduos");
