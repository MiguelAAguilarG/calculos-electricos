%Programa para calcular calibres de conductores para un solo alimentador 
%o circuito derivado basado en la NOM-001-SEDE-2012
clear all;
close all;
clc;
%DATOS DE ENTRADA
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%///////////////////////////////////////////////////////////////////////////////

datos(1)=3; %1. Sistema(1,3)
datos(2)=460; %2. Voltaje(V)
datos(3)=515*460*.79; %3. Carga(W)
datos(4)=1.25; %4. Factor de carga
datos(5)=0.79; %5. factor de potencia (>0-1)
datos(6)=3; %6. Caída de tensión(%)
datos(7)=55; %7. Longitud(m)
datos(8)=0; %8. Conductores activos adicionales en la misma canalización aparte del circuito calculado. El programa no considera los neutros (sistemas trifásicos) y tierras fisicas del circuito calculado.
datos(9)=40; %9. Temperatura ambiente(°C)
datos(10)=75; %10. Temperatura del aislante del conductor(°C)
datos(11)=1; %11. Material del conductor: Cobre(1), Aluminio(2)
datos(12)=3; %12. Conductores por fase
datos(13)=0; %13. Total de conductores de fase en la misma canalización?: Si(1) No(0)
datos(14)=0; %14. Ajuste hacia abajo en caso de no encontrar interruptor cercano con Factor de carga establecido(Factor de carga-Ajuste/100) (%)
datos(15)=80; %15. Ajuste Irating interruptor (%)
datos(16)=800; %16. Interruptor forzado (A) NOTA: NO APLICA = 0 
datos(17)=2; %17. Canalizacion: Conduit(1), Charola(2)
datos(18)=2; %18. Material Canalizacion: Acero(1), PVC(2), Aluminio(3)
datos(19)=0; %19. Neutro sistema trifasico: SI(1), NO(0)

numero_datos = 19;%Variable de control
%DATOS DE ENTRADA (Explicación)
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%///////////////////////////////////////////////////////////////////////////////
%1. Sistema NOTA: Indicará error sino es 1 O 3
%Monofásico(1) o Trifásico(3)
%///////////////////////////////////////////////////////////////////////////////
%2. Voltaje(V) NOTA: Indicará error si es un valor menor o igual a 0
%Voltajes sugeridos. NOM-001-SEDE-2012. 220-5(a). 110-4
%Monofásicos  Trifásicos
%120          208
%127          220 => Valores usuales
%240          ---
%---          440
%277          480
%347          600
%///////////////////////////////////////////////////////////////////////////////
%3. Carga(W) NOTA: Indicará error si es una carga menor o igual a 0
%///////////////////////////////////////////////////////////////////////////////
%4. Factor de correción para cargas NOTA: Para cargas continuas se considera 1.25.
%                                   NOM-001-SEDE-2012. 210-19(a)(1)
%                                   NOM-001-SEDE-2012. 210-20(a)
%                                   NOM-001-SEDE-2012. 215-2(a)(1)
%                                   NOM-001-SEDE-2012. 215-3
%                                   NOTA: Indicará error si el factor de correción
%                                   es menor o igual a 0
%///////////////////////////////////////////////////////////////////////////////
%5. factor de potencia(>0-1) NOTA: Indicará error si es un factor de potencia
%                            menor o igual a 0, y si es mayor a 1
%///////////////////////////////////////////////////////////////////////////////
%6. Caída de tensión(%) NOTA: Limitada a 3% (NOM-001-SEDE-2012)
%                       NOM-001-SEDE-2012. 215-2(a)(4) NOTA 2
%                       NOM-001-SEDE-2012. 210-19(a)(1) NOTA 4
%                       NOTA: Indicará error si la caida de tensión es menor o igual a 0
%///////////////////////////////////////////////////////////////////////////////
%7. Longitud(m) NOTA: Indicará error si es una longitud menor o igual a 0
%               NOTA: Factor de agrupamiento no aplica para 60 cm o menos
%               310-15. (b)(3)(a)(2)
%///////////////////////////////////////////////////////////////////////////////
%8. Conductores en la canalización  NOTA: Limitado a 50 conductores por cuestiones 
%                                   practicas. Tabla 310-15(b)(3)(a)
%                                   NOTA: Indicará error si el numero de conductores 
%                                   es menor a 2 (No tendría sentido practico)
%                                   NOTA: Solo numeros enteros, si se ingresa decimaes,
%                                   se redondeará
%///////////////////////////////////////////////////////////////////////////////
%9. Temperatura ambiente(°C)
%///////////////////////////////////////////////////////////////////////////////
%10. Temperatura del aislante del conductor(°C) NOTA: Solo se deben de considerar las 
%                                               siguientes temperaturas de conductores:
%                                               60°C, 75°C, 90°C por cuestiones de 
%                                               disponibilidad de datos en el programa
%                                               NOTA: Se recomienda usar temperatura
%                                               del conductor de 60°C en casos de
%                                               circuitos de 100A o con calibres de 1
%                                               o menores, por cuestiones de limitaciones
%                                               de temperatura en terminales de equipos
%                                               y usar 90°C en circuitos mayores de 100A
%                                               o calibres mayores a 1.
%                                               NOM-001-SEDE-2012. 220-5(a). 110-14(c)(1)
%///////////////////////////////////////////////////////////////////////////////
%11. Material del conductor: Cobre(1), Aluminio(2);
%///////////////////////////////////////////////////////////////////////////////
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%TABLAS
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%///////////////////////////////////////////////////////////////////////////////
%Tabla 310-15(b)(3)(a). Factores de ajuste para más de tres conductores portadores de corriente en una canalización o cable

%Numero de conductores(1) Porcentajes de los valores en las tablas 310-15(b)(16)
%4-6                      80
%7-9                      70
%10-20                    50
%21-30                    45
%31-40                    40
%41 y más                 35
%(1) Es el número total de conductores en la canaización o cable ajustado de acuerdo con 310-15(b)(5) y (6)

tabla_numero_conductores = [3 6 9 20 30 40 50];
tabla_factor_agrupamiento = [1 0.8 0.7 0.5 0.45 0.4 0.35];
%///////////////////////////////////////////////////////////////////////////////
%Tabla 310-15(b)(16). Ampacidad permisible en conductores aislados para tensiones
%hasta 2000 volts y 60°C a 90°C. No más de tres condcutores portadores de corriente
%en un canalización, cable o directamente enterrados, basados en una temperatura ambiente
%de 30°C

%Tamaño o designación - %Temperatura nominal del conductor [Vease la table 310-104(a)]
%-------------------------------------------------------------------------------
%                     -  Cobre                   
%mm^2     AWG o       -  60°C    75°C    90°C
%0.824    18          -                  14
%1.31     16          -                  18
%2.08     14          -  15      20      25
%3.31     12          -  20      25      30
%5.26     10          -  30      35      40  
%8.37     8           -  40      50      55
%13.3     6           -  55      65      75
%21.2     4           -  70      85      95
%26.7     3           -  85      100     115
%33.6     2           -  90      115     130
%42.4     1           -  110     130     145
%53.49    1/0         -  125     150     170
%67.43    2/0         -  145     175     195
%85.01    3/0         -  165     200     225
%107.2    4/0         -  195     230     260
%127      250         -  215     255                                                            
%152      300         -  240     285                                                 
%177      350         -  260     310                                                           
%203      400         -  280     335                                                            
%253      500         -  320     380                                                              
%304      600         -  350     420                                                          
%355      700         -  385     460                                                                    
%380      750         -  400     475                                                              
%405      800         -  410                                                                 
%456      900         -  435                                                                 
%507      1000        -  455                                                             
%633      1250        -  495                                                                            
%700      1500        -  525                                                                      
%887      1750        -  545                                                                    
%1013     2000        -  555                      -

Area_tabla = [2.08 3.31 5.26 8.37 13.3 21.2 26.7 33.6 42.4 53.49 67.43 85.01 ... 
107.2 127 152 177 203 253 304 355 380 405 456 507 633 700 887 1013];          
calibre_tabla = {14,12,10,8,6,4,3,2,1,'1/0','2/0','3/0','4/0',250,300,350,400, ...
500,600,700,750,800,900,1000,1250,1500,1750,2000};
Ampacidad_tablas(:,1,1) = [15 20 30 40 55 70 85 90 110 125 145 165 195 215 240 ...
260 280 320 350 385 400 410 435 455 495 525 545 555];
Ampacidad_tablas(:,2,1) = [20 25 35 50 65 85 100 115 130 150 175 200 230 255 285 ...
310 335 380 420 460 475 490 520 545 590 625 650 665];
Ampacidad_tablas(:,3,1) = [25 30 40 55 75 95 115 130 145 170 195 225 260 290 320 ...
350 380 430 475 520 535 555 585 615 665 705 735 750];
Ampacidad_tablas(:,1,2) = [0 0 0 0 40 55 65 75 85 100 115 130 150 170 195 210 225 ...
260 285 315 320 330 355 375 405 435 455 470];
Ampacidad_tablas(:,2,2) = [0 0 0 0 50 65 75 90 100 120 135 155 180 205 230 250 270 ...
310 340 375 385 395 425 445 485 520 545 560];
Ampacidad_tablas(:,3,2) = [0 0 0 0 55 75 85 100 115 135 150 175 205 230 260 280 305 ...
350 385 425 435 445 480 500 545 585 615 630];
%///////////////////////////////////////////////////////////////////////////////
%TABLA 250-122.- Tamaño minimo de los conductores de puesta a tierra para canalizaciones y equipos
%Capacidad o ajuste del   - Cobre
%dispositivo automático   - 
%de protección contra     -
%sobrecorriente en el     -
%circuito antes de los    -
%equipos, canalizaciones, -
%etc., sin exceder de:    -
%(amperes)                -
%15                       -    
%20
%60
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
interruptor_tierra_tablas = [15 20 60 100 200 300 400 500 600 800 1000 1200 1600 ...
2000 2500 3000 400 4000 5000 6000];
tierra_tablas(:,1) = {14,12,10,8,6,4,2,2,1,'1/0','2/0','3/0','4/0',250,350,400, ...
500,700,800};
tierra_tablas(:,2) = {0,0,0,0,4,2,1,'1/0','2/0','3/0','4/0',250,350,400, ...
600,600,750,1200,1200};
%///////////////////////////////////////////////////////////////////////////////
%Capítulo 10
%TABLAS
%Tabla 9 (ohm*km)
reactancia_tablas(:,1) = [0.190 0.177 0.164 0.171 0.167 0.157 0.154 0.148 0.151 0.144 0.141 0.138 0.135 0.135 0.135 0.131 0.131 0.128 0.128 0.125 0.121];%PVC
reactancia_tablas(:,2) = reactancia_tablas(:,1);%Aluminio
reactancia_tablas(:,3) = [0.240 0.223 0.207 0.213 0.210 0.197 0.194 0.187 0.187 0.180 0.177 0.171 0.167 0.171 0.167 0.164 0.161 0.157 0.157 0.157 0.151];%Acero
resistencia_tablas(:,1,1) = [10.2 6.6 3.9 2.56 1.61 1.02 0.82 0.62 0.49 0.39 0.33 0.253 0.203 0.171 0.144 0.125 0.108 0.089 0.075 0.062 0.049];%PVC
resistencia_tablas(:,2,1) = [10.2 6.6 3.9 2.56 1.61 1.02 0.82 0.66 0.52 0.43 0.33 0.269 0.220 0.187 0.161 0.141 0.125 0.105 0.092 0.079 0.062];%Aluminio
resistencia_tablas(:,3,1) = [10.2 6.6 3.9 2.56 1.61 1.02 0.82 0.66 0.52 0.39 0.33 0.259 0.207 0.177 0.148 0.128 0.115 0.095 0.082 0.069 0.059];%Acero 
resistencia_tablas(:,1,2) = [0 0 0 0 2.66 1.67 1.31 1.05 0.82 0.66 0.52 0.43 0.33 0.279 0.233 0.200 0.177 0.141 0.118 0.095 0.075];%PVC
resistencia_tablas(:,2,2) = [0 0 0 0 2.66 1.67 1.31 1.05 0.85 0.69 0.52 0.43 0.36 0.295 0.249 0.217 0.194 0.157 0.135 0.112 0.089];%Aluminio
resistencia_tablas(:,3,2) = [0 0 0 0 2.66 1.67 1.31 1.05 0.82 0.66 0.52 0.43 0.33 0.282 0.236 0.207 0.180 0.148 0.125 0.102 0.082];%Acero 
%///////////////////////////////////////////////////////////////////////////////
%Interruptores Square D usuales
Interruptores = [10 15 20 30 40 50 60 70 80 90 100 125 150 175 200 225 250 300 400 500 600 700 800 1000 1200 1600 2000];
%///////////////////////////////////////////////////////////////////////////////
%Area cable THHW
%Capítulo 10
%TABLAS
%Tabla 5. Dimensiones de los conductores aislados y cables para artefactos (Inconclusa)
Area_cable_tablas = [8.968 11.68 15.68 28.19 46.84 62.77 73.16 86.00 122.60 143.40 169.30 201.1 239.90 296.5 340.7 384.40 427.00 509.70 627.7 710.3 751.7 791.7 874.9 953.8 1200 1400 1598 1795];
Diametro_cable_tablas = [3.378 3.861 4.470 5.994 7.722 8.941 9.652 10.46 12.50 13.51 14.68 16.00 17.48 19.43 20.83 22.12 23.32 25.48 28.27 30.07 30.94 31.75 33.38 34.85 39.09 42.21 45.1 47.80];
%///////////////////////////////////////////////////////////////////////////////
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

%VALIDACIÓN DE DATOS
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%///////////////////////////////////////////////////////////////////////////////

n_errores = 0;
n = 0;
if length(datos) ~= numero_datos
  disp('!ERROR. Los datos no estan completos');
  n_errores = n_errores + 1;
end
n = n + 1; 
Sistema = datos(n);
if Sistema ~= 1 && Sistema ~= 3
  disp('!ERROR. El sistema ingresado no es correcto. Debe ser trifasico(3) o monofasico(1)');
  n_errores = n_errores + 1; 
end
n = n + 1; 
Voltaje = datos(n);
if Voltaje <= 0
  disp('!ERROR. El voltaje es menor o igual a 0');
  n_errores = n_errores + 1;
end
n = n + 1; 
Carga = datos(3);
if Carga <= 0
  disp('!ERROR. La carga es menor o igual a 0');
  n_errores = n_errores + 1;
end
n = n + 1; 
factor_carga = datos(n);
if factor_carga <= 0
  disp('!ERROR. El factor de correcion es menor o igual a 0');
  n_errores = n_errores + 1;
end
n = n + 1; 
fp = datos(n);
if fp < 0
  disp('!ERROR. El factor de potencia es menor a 0');
  n_errores = n_errores + 1;
elseif fp > 1
  disp('!ERROR. El factor de potencia es mayor a 1');
  n_errores = n_errores + 1;
end
n = n + 1; 
caida_tension = datos(n);
if caida_tension <= 0
  disp('!ERROR. La caida de tension es menor o igual a 0%');
  n_errores = n_errores + 1;
elseif caida_tension > 3
  disp('!ERROR. La caida de tension es mayor a 3%');
  n_errores = n_errores + 1;
end
n = n + 1; 
Longitud = datos(n);
if Longitud <= 0
  disp('!ERROR. La longitud es menor o igual a 0');
  n_errores = n_errores + 1;
end
n = n + 1; 
conductores_canalizacion = round(datos(n));
if conductores_canalizacion < 0
  disp('!ERROR. El numero de conductores es menor a 0');
  n_errores = n_errores + 1;
elseif conductores_canalizacion > 50
  disp('!ERROR. El numero de conductores es mayor a 50. Son demasiados conductores');
  n_errores = n_errores + 1;
end
n = n + 1; 
Tambiente = datos(n);
n = n + 1; 
Tconductor = datos(n); 
if Tconductor ~= 60 && Tconductor ~= 75 && Tconductor ~= 90
  disp('!ERROR. La temperatura del conductor no es correcta');
  n_errores = n_errores + 1;
end
n = n + 1;   
material_conductor = datos(n);
if material_conductor ~= 1 && material_conductor ~= 2
  disp('!ERROR. El material del conductor no es el correcto');
  n_errores = n_errores + 1;
end
n = n + 1; 
numero_conductores = round(datos(n));
if numero_conductores <= 0
  disp('!ERROR. El numero de conductores por fase es menor o igual a 0');
  n_errores = n_errores + 1;
end
n = n + 1; 
mismo = round(datos(n));
if mismo ~= 1 && mismo ~= 0
  disp('!ERROR. Dato no valido para fases en la misma canalizacion. Dato %d',mismo);
  n_errores = n_errores + 1;
end
n = n + 1;
ajuste_factor_carga = datos(n);
if ajuste_factor_carga <0 || ajuste_factor_carga > 100
  disp('!ERROR. Dato no valido. No correcponde a un porcentaje real');
  n_errores = n_errores + 1;
end
n = n + 1;
porcentaje_Irating = datos(n);
if porcentaje_Irating <=0 || porcentaje_Irating > 100
  disp('!ERROR. Dato no valido. No correcponde a un porcentaje real');
  n_errores = n_errores + 1;
end
n = n + 1;
Interruptor_forzado = datos(n);
if Interruptor_forzado <0
  disp('!ERROR. Dato no valido. Amperaje de interruptor negativo');
  n_errores = n_errores + 1;
end
n = n + 1;
canalizacion = datos(n);
if canalizacion ~= 1 && canalizacion ~= 2
  disp('!ERROR. Dato no valido. No es una canalizacion');
  n_errores = n_errores + 1;
end
n = n + 1;
material_canalizacion = datos(n);
if material_canalizacion ~= 1 && material_canalizacion ~= 2 && material_canalizacion ~= 3
  disp('!ERROR. Dato no valido. No es un material de canalizacion');
  n_errores = n_errores + 1;
end
n = n + 1;
neutro = datos(n);
if neutro ~= 1 && neutro ~= 0
  disp('!ERROR. Dato no valido para el valor neutro');
  n_errores = n_errores + 1;
end
n = n + 1;
if n_errores > 0
  disp('Numero de errores: ');
  disp(n_errores);
  disp(' ');
end
fprintf('1. Sistema = %d\n',Sistema);
fprintf('2. Voltaje (Voltaje) = %f\n',Voltaje);
fprintf('3. Carga (W)= %f\n',Carga);
fprintf('4. Factor de carga = %f\n',factor_carga);
fprintf('5. Factor de potencia = %0.f\n',fp);
fprintf('6. Caida de tension (%%) = %f\n',caida_tension);
fprintf('7. Longitud (m) = %f\n',Longitud);
fprintf('8. Conductores activos adicionales del circuito en la misma canalizacion = %d\n',conductores_canalizacion);
fprintf('9. Temperatura ambiente (°C) = %f\n',Tambiente);
fprintf('10. Temperatura del aislante del conductor (°C) = %d\n',Tconductor);
fprintf('11. Material del conductor: Cobre(1), Aluminio(2) = %d\n',material_conductor);
fprintf('12. Numero de conductores por fase = %d\n',numero_conductores);
fprintf('13. Total de fases en la misma canalización?: Si(1) No(0) = %d\n',mismo);
fprintf('14. Ajuste de factor de carga establecido(factor de carga-Ajuste/100) (%%) = %f\n',ajuste_factor_carga);
fprintf('15. Ajuste de Irating interruptor (%%) = %f\n',porcentaje_Irating);
fprintf('16. Interruptor forzado (A) = %f\n',Interruptor_forzado);
fprintf('17. Canalizacion: Conduit(1), Charola(2) = %d\n',canalizacion);
fprintf('18. Material Canalizacion: Acero(1), PVC(2), Aluminio(3) = %d\n',material_canalizacion);
fprintf('19. Neutro sistema trifasico: SI(1), NO(0) = %d\n',neutro);
disp('\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\');

%///////////////////////////////////////////////////////////////////////////////
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------


%PROCESO
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%///////////////////////////////////////////////////////////////////////////////
if Sistema == 1
  I_nom = Carga/(Voltaje*fp);
  I_calculada = I_nom*factor_carga;
  neutro = 1;
  
  if mismo ==1
  conductores_canalizacion = numero_conductores*mismo + neutro*numero_conductores*mismo + conductores_canalizacion;  
  else
  conductores_canalizacion = 1 + neutro + conductores_canalizacion;  
  end

elseif Sistema == 3
  I_nom = Carga/(sqrt(3)*Voltaje*fp);
  I_calculada = I_nom*factor_carga;
  
  if mismo ==1
  conductores_canalizacion = 3*numero_conductores*mismo + neutro*numero_conductores*mismo + conductores_canalizacion;  
  else
  conductores_canalizacion = 3 + neutro + conductores_canalizacion;  
  end

end

Carga_corregida = Carga*factor_carga;%Carga corregida
%///////////////////////////////////////////////////////////////////////////////
Interruptores = Interruptores*porcentaje_Irating/100;
Interruptor_forzado = Interruptor_forzado*porcentaje_Irating/100;

if Interruptor_forzado == 0
  
for n=1:length(Interruptores) %Determinar interruptor
  if I_calculada <= Interruptores(n)
  Interruptor = Interruptores(n);
  break
  elseif I_nom*(factor_carga-ajuste_factor_carga/100) <= Interruptores(n)
  Interruptor = Interruptores(n);
  break
  end
end
else
  Interruptor = Interruptor_forzado;
end
%///////////////////////////////////////////////////////////////////////////////
Tconductor_tablas = [60 75 90];%Temperatura del aislante del conductor
Tambiente_tablas = [30 40];%Este valor se toma de las tablas de ampacidad de los conductores

for n=1:length(Tconductor_tablas)
if Tconductor_tablas(n) == Tconductor
  posicion_tablas_temperatura = n;
  break
end
end
factor_temperatura = sqrt((Tconductor-Tambiente)/(Tconductor-Tambiente_tablas(1)));

for n=1:length(tabla_numero_conductores) %Determinar factor de agrupamiento NOTA: Ir a la Tabla 310-15(b)(3)(a)
  if conductores_canalizacion <= tabla_numero_conductores(n)
  factor_agrupamiento = tabla_factor_agrupamiento(n);
  break
  end
end
if Longitud <= 0.6 %Factor de agrupamiento no aplica para 60 cm o menos. 310-15. (b)(3)(a)(2)
factor_agrupamiento = 1;
end

Ampacidad_tablas_corregida(:,posicion_tablas_temperatura,material_conductor) = Ampacidad_tablas(:,posicion_tablas_temperatura,material_conductor)*factor_agrupamiento*factor_temperatura;%Ampacidad corregida

aux_2 = 1;
while aux_2 <= length(Ampacidad_tablas_corregida(:,posicion_tablas_temperatura,material_conductor))
  while aux_2 <= length(Ampacidad_tablas_corregida(:,posicion_tablas_temperatura,material_conductor))
    if Ampacidad_tablas_corregida(aux_2,posicion_tablas_temperatura,material_conductor) >= Interruptor/numero_conductores 
    calibre = calibre_tabla(aux_2);
    Area = Area_tabla(aux_2);
    Ampacidad = Ampacidad_tablas(aux_2,posicion_tablas_temperatura,material_conductor);
    Ampacidad_corregida = Ampacidad_tablas_corregida(aux_2,posicion_tablas_temperatura,material_conductor);
      if Area < 53 && numero_conductores > 1
      disp('!ERROR. Tamano de conductor menor a 1/0. No se puede poner ese tamano de conductor en paralelo.');
      disp('');
      break
      break
    end
    break
    end
    aux_2 = aux_2 + 1;
        if aux_2 > length(Ampacidad_tablas_corregida(:,posicion_tablas_temperatura,material_conductor))
        disp('!ERROR. Tamano de conductor demasiado grande. Fuera de rango de las tablas.');
        disp('Se recomienda aumentar numero de conductores por fase');
        disp('');
        break
        break
        end
  end
%///////////////////////////////////////////////////////////////////////////////
if material_canalizacion == 1
  material_canalizacion = 3;
elseif material_canalizacion == 2
  material_canalizacion = 1;
elseif material_canalizacion == 3
  material_canalizacion = 2;
end

resistencia_de_tablas = resistencia_tablas(aux_2,material_canalizacion);
reactancia_de_tablas = reactancia_tablas(aux_2,material_canalizacion);

Ze = (resistencia_tablas(aux_2,material_canalizacion)*fp + reactancia_tablas(aux_2,material_canalizacion)*sin(acos(fp)))/1000;

  if Sistema == 1
    caida_tension_calculada = 2*Ze*Longitud*I_nom*100/Voltaje/numero_conductores;
  elseif Sistema == 3
    caida_tension_calculada = sqrt(3)*Ze*Longitud*I_nom*100/Voltaje/numero_conductores;
  end
  %
  if caida_tension_calculada > caida_tension
    aux_2 = aux_2 + 1;
  else
    break
  end
        if aux_2 > length(Ampacidad_tablas_corregida(:,posicion_tablas_temperatura,material_conductor))
        disp('!ERROR. Tamano de conductor demasiado grande. Fuera de rango de las tablas.');
        disp('Se recomienda aumentar numero de conductores por fase');
        disp('');
        break
        end
%///////////////////////////////////////////////////////////////////////////////
end 
%///////////////////////////////////////////////////////////////////////////////
for n=1:length(interruptor_tierra_tablas)
  if Interruptor*porcentaje_Irating/100 <= interruptor_tierra_tablas(n)
  tierra = tierra_tablas(n,material_conductor);
    if cell2mat(tierra) == 0
    tierra = tierra_tablas(5,material_conductor);
    disp('NOTA: Se forzo conductor de aluminio de tierra fisica a calibre 6');
    break
    end
  break
  end
end
%///////////////////////////////////////////////////////////////////////////////
%///////////////////////////////////////////////////////////////////////////////
for n=1:length(calibre_tabla)
  if cell2mat(tierra) == cell2mat(calibre_tabla(n))
  aux_3 = n;
  
  if canalizacion == 2 && aux_3 <=5
  disp('NOTA. Tierra fisica forzada a calibre 4 por estar en charola');
  aux_3 = 6;  
  end
  
  break
  end
end
Area_cable = conductores_canalizacion*Area_cable_tablas(aux_2)+Area_cable_tablas(aux_3);
%///////////////////////////////////////////////////////////////////////////////
%///////////////////////////////////////////////////////////////////////////////
ancho_charola_tablas = [50 100 150 200 225 300 400 450 500 600 750 900];
charola_columna1 = [1400 2800 4200 5600 6100 8400 11200 12600 14000 16800 21000 25200];
if canalizacion == 2
  
if Sistema == 1
  suma_diametros = 1*numero_conductores*Diametro_cable_tablas(aux_2) + neutro*numero_conductores*Diametro_cable_tablas(aux_2) + Diametro_cable_tablas(aux_3);
  suma_area = 1*numero_conductores*Area_cable_tablas(aux_2) + neutro*numero_conductores*Area_cable_tablas(aux_2) + Area_cable_tablas(aux_3);
elseif Sistema == 3
  suma_diametros = 3*numero_conductores*Diametro_cable_tablas(aux_2) + neutro*numero_conductores*Diametro_cable_tablas(aux_2) + Diametro_cable_tablas(aux_3);
  suma_area = 3*numero_conductores*Area_cable_tablas(aux_2) + neutro*numero_conductores*Area_cable_tablas(aux_2) + Area_cable_tablas(aux_3);
end

%///////////////////////////////////////////////////////////////////////////////
  if aux_2 >= 24 && aux_3 >= 24
    condicion = 'a';
    for n=1:length(ancho_charola)
      if suma_diametros <= ancho_charola_tablas(n)
        ancho_charola = ancho_charola_tablas(n);
        break
      end
    end
%///////////////////////////////////////////////////////////////////////////////
  elseif (aux_2 >= 14 && aux_2 <= 23) && (aux_3 >= 14 && aux_3 <= 23)
    condicion = 'b';
    for n=1:length(ancho_charola_tablas)
      if suma_area <= charola_columna1(n)
        ancho_charola = ancho_charola_tablas(n);
        break
      end
    end
%///////////////////////////////////////////////////////////////////////////////
  elseif aux_2 >= 24 && aux_3 < 24
    condicion = 'c';
    Sd = Diametro_cable_tablas(aux_2)*conductores_canalizacion;
    charola_columna2 = charola_columna1 - 28*Sd;
    for n=1:length(ancho_charola_tablas)
      if suma_area <= charola_columna2(n)
        ancho_charola = ancho_charola_tablas(n);
        break
      end
    end
%///////////////////////////////////////////////////////////////////////////////
  elseif (aux_2 >= 6 && aux_2 <= 13) || (aux_3 >= 6 && aux_3 <= 13)
    condicion = 'd';
    for n=1:length(ancho_charola_tablas)
      if suma_diametros <= ancho_charola_tablas(n)
        ancho_charola = ancho_charola_tablas(n);
        break
      end
    end
  else
    disp('Error. Diametro de conductor activo menor a calibre 4');
  end
%///////////////////////////////////////////////////////////////////////////////
    if suma_diametros ~=0
      suma_area = 0;
    elseif suma_area ~= 0
      suma_diametros =0
    end
end
%///////////////////////////////////////////////////////////////////////////////
%///////////////////////////////////////////////////////////////////////////////
fprintf('I nominal (A) = %f\n',I_nom);
fprintf('Carga corregida (W) = %f\n',Carga_corregida);
fprintf('I calculada (A) = %f\n\n',I_calculada);

fprintf('Interruptor (A)= %d\n',Interruptor);
fprintf('Tamano del conductor = %s\n',num2str(cell2mat(calibre)));
fprintf('Seccion transversal (mm^2) = %f\n',Area);
fprintf('Tierra fisica del circuito (cobre) = %s\n\n',num2str(cell2mat(calibre_tabla(aux_3))));

fprintf('factor de agrupamiento = %f\n',factor_agrupamiento);
fprintf('factor de temperatura = %f\n\n',factor_temperatura);

fprintf('Numero de conductores activos totales en la canalizacion = %d\n\n',conductores_canalizacion);

fprintf('Ampacidad del conductor en tablas (A) = %d\n',Ampacidad);
fprintf('Ampacidad del conductor corregida (A) = %f\n\n',Ampacidad_corregida);

fprintf('***Solo toma valores de la TABLA 9***\n');
fprintf('Caida de tension calculada (%%) = %f\n',caida_tension_calculada);
fprintf('Resistencia de tablas (ohms/km) = %f\n',resistencia_de_tablas);
fprintf('Reactancia de tablas (ohms/km) = %f\n\n',reactancia_de_tablas);

fprintf('***Solo da valores de cable TW,THW,THW-2,THHW***\n');
fprintf('Area total de los conductores calculados en el ducto (Activos +  Tierra) = %f\n\n',Area_cable);

fprintf('Area del cable de fase = %f\n',Area_cable_tablas(aux_2));
if neutro == 1
fprintf('Area del cable de neutro = %f\n',Area_cable_tablas(aux_2));
end
fprintf('Area del cable de tierra con forro = %f\n\n',Area_cable_tablas(aux_3));

fprintf('Diametro del cable de fase = %f\n',Diametro_cable_tablas(aux_2));
if neutro == 1
fprintf('Diametro del cable de neutro = %f\n',Diametro_cable_tablas(aux_2));
end
fprintf('Diametro del cable de tierra con forro = %f\n\n',Diametro_cable_tablas(aux_3));

if canalizacion == 2
fprintf('***CHAROLA***\n');
fprintf('***399-122(b)(1)***\n');
fprintf('Condicion: %c\n',condicion);
fprintf('Suma de diametros = %f\n',suma_diametros);
fprintf('Suma de areas = %f\n',suma_area);
fprintf('Ancho de la charola = %d\n',ancho_charola);
end 
%///////////////////////////////////////////////////////////////////////////////

