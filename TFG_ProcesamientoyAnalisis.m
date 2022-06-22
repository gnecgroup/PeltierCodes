% Ana Belén Díaz Dochado
% Email: anabelendiaz99@gmail.com

%% 1. Filtrado de la señal estimulación calor.
%Registro 2,a 1,3mm de profundidad y 1,2% de anestesia.
% Artefactos a eliminar: línea base, cuando echa suero, 50Hz, cuando
% comienza el estímulo se cuela ruido eléctrico del sistema con Peltier
%Capa1= C12 y C13; Capa2/3= C9,C10 y C11; Capa4= C7 y C8; Capa5= C4, C5 y
%C6; Capa6= C1,C2 y C3. Los C14, C15 y C16 no se cuentan.
% Se van a analizar los siguientes canales: C5

C5=load('Canal5_O.mat');

%La frecuencia de muestreo es 40kHz,al ser un registro largo y con tantas muestras por segundo se ha decidido 'downsamplear'.

fs=400;
t=C5.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch5.times;
x_C5=C5.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch5.values;
dt=downsample(t,100);
dx_C5=downsample(x_C5,100);

%Se filtra la línea base, con un filtro paso banda de 0,5 Hz a 100 Hz

filtro_min=0.5;
filtro_max=100;
x_filt_C5=bandpass(dx_C5, [filtro_min filtro_max], fs);

%Se filtra con filtro banda eliminada el ruido de la red de 50 Hz.  
[b2,a2]=butter(3,(2/fs)*[49 51],'stop');
x_filt2_C5=filtfilt(b2,a2,x_filt_C5');

%Se representa la señal filtrada
figure
plot(dt,x_filt2_C5);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Señal filtrada del Canal 5 (Capa 5)');
ylim([-0.3 0.2]);
xlim([0 700]);

%% 2. Detección de los estímulos
% Se detecta la actividad espontánea antes del estímulo en cada canal y se
% guarda en un vector tanto los valores como los tiempos
%Se carga el canal de eventos común a todos los canales de registro.
CEventos=load('CanalEventos1.mat');
%Se aigna el primer evento del canal de eventos al inicio del estimulo 1.
Testimulo1inicio=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(1);
%Deteccion estimulo 1
y=fix(CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times);
for a=2:length(y)
   if y(a)~=y(1)
    Testimulo1fin=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(a);
    indice1=a;
   break
   end 
end
%Deteccion estimulo 2
for b=a:length(y)
   if y(b)~=y(a)
    Testimulo2inicio=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(b);
    indice2=b;
   break
   end 
end
for c=b:length(y)
   if y(c)~=y(b)
    Testimulo2fin=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(c);
    indice3=c;
   break
   end 
end
%Deteccion estimulo 3
for d=c:length(y)
   if y(d)~=y(c)
    Testimulo3inicio=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(d);
    indice2=d;
   break
   end 
end
for e=d:length(y)
   if y(e)~=y(d)
    Testimulo3fin=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(e);
    indice3=e;
   break
   end 
end
%Deteccion estimulo 4
for f=e:length(y)
   if y(f)~=y(e)
    Testimulo4inicio=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(f);
    indice2=f;
   break
   end 
end
for g=f:length(y)
   if y(g)~=y(f)
    Testimulo4fin=CEventos.Peltier2_2_010_stim_heat_1_3mm_1_2_iso__LFP_MUAr_Ch18.times(g);
    indice3=g;
   break
   end 
end
%Se crean los vectores correspondientes a cada estimulo de cada canal
%Canal 3
%Se crea el vector estimulo 1
[minimoE1,posicionTestimulo1inicio]=min(abs(dt-Testimulo1inicio));
estimulo1_valores_C5=x_filt2_C5(posicionTestimulo1inicio:posicionTestimulo1inicio+24000);
estimulo1_tiempos=dt(posicionTestimulo1inicio:posicionTestimulo1inicio+24000);

%Se crea el vector estimulo 2
[minimoE2,posicionTestimulo2inicio]=min(abs(dt-Testimulo2inicio));
estimulo2_valores_C5=x_filt2_C5(posicionTestimulo2inicio:posicionTestimulo2inicio+24000);
estimulo2_tiempos=dt(posicionTestimulo2inicio:posicionTestimulo2inicio+24000);

%Se crea el vector estimulo 3
[minimoE3,posicionTestimulo3inicio]=min(abs(dt-Testimulo3inicio));
estimulo3_valores_C5=x_filt2_C5(posicionTestimulo3inicio:posicionTestimulo3inicio+24000);
estimulo3_tiempos=dt(posicionTestimulo3inicio:posicionTestimulo3inicio+24000);

%Se crea el vector estimulo 4
[minimoE4,posicionTestimulo4inicio]=min(abs(dt-Testimulo4inicio));
estimulo4_valores_C5=x_filt2_C5(posicionTestimulo4inicio:posicionTestimulo4inicio+24000);
estimulo4_tiempos=dt(posicionTestimulo4inicio:posicionTestimulo4inicio+24000);

%Se representan los 4 estimulos.
figure
subplot(2,2,1)
plot(estimulo1_tiempos,estimulo1_valores_C5);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Señal estimulo 1 del Canal 5');
subplot(2,2,2)
plot(estimulo2_tiempos,estimulo2_valores_C5);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Señal estimulo 2 del Canal 5');
subplot(2,2,3)
plot(estimulo3_tiempos,estimulo3_valores_C5);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Señal estimulo 3 del Canal 5');
subplot(2,2,4)
plot(estimulo4_tiempos,estimulo4_valores_C5);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Señal estimulo 4 del Canal 5');

%% 3. Representación de las señales: 

%15 segundos actividad espontánea (basal) y 60 segundos después de que comience el estímulo
%Canal 5, los 4 estímulos
canal5_s_E1=x_filt2_C5(posicionTestimulo1inicio-5999:posicionTestimulo1inicio+24000);
tiempos_s_E1=dt(posicionTestimulo1inicio-5999:posicionTestimulo1inicio+24000);

canal5_s_E2=x_filt2_C5(posicionTestimulo2inicio-5999:posicionTestimulo2inicio+24000);
tiempos_s_E2=dt(posicionTestimulo2inicio-5999:posicionTestimulo2inicio+24000);

canal5_s_E3=x_filt2_C5(posicionTestimulo3inicio-5999:posicionTestimulo3inicio+24000);
tiempos_s_E3=dt(posicionTestimulo3inicio-5999:posicionTestimulo3inicio+24000);

canal5_s_E4=x_filt2_C5(posicionTestimulo4inicio-5999:posicionTestimulo4inicio+24000);
tiempos_s_E4=dt(posicionTestimulo4inicio-5999:posicionTestimulo4inicio+24000);

%Representación
figure
subplot(4,1,1)
plot(tiempos_s_E1,canal5_s_E1);
title('Estímulo 1 canal 5 (capa 5)');
xlim([0 75]);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Potencial (mV)' ); 
subplot(4,1,2)
plot(tiempos_s_E2,canal5_s_E2);
title('Estímulo 2 canal 5 (capa 5)');
xlim([120 195]);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Potencial (mV)' ); 
subplot(4,1,3)
plot(tiempos_s_E3,canal5_s_E2);
title('Estímulo 3 canal 5 (capa 5)');
xlim([254 329]);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Potencial (mV)' ); 
subplot(4,1,4)
plot(tiempos_s_E4,canal5_s_E4);
title('Estímulo 4 canal 5 (capa 5)');
xlim([413.25 488.25]);
xlabel ( 'Tiempo (s)' );
ylabel ( 'Potencial (mV)' ); 

%% 4. Detección y cálculo de las amplitudes de la actividad espontánea antes de cada estímulo
%Se crea el vector de actividad espontanea del canal antes de cada estímulo
%y se representan
%Detección
actEspontanea_tiempos_preE1=dt(2008:posicionTestimulo1inicio-20);
actEspontanea_valores_preE1_C5=x_filt2_C5(2008:posicionTestimulo1inicio-20);
figure
subplot(2,2,1)
plot(actEspontanea_tiempos_preE1, actEspontanea_valores_preE1_C5); 
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Actividad espontanea antes del estímulo 1 canal 5 (Capa 5)');
ylim([-0.2 0.1]);

actEspontanea_tiempos_preE2=dt(posicionTestimulo2inicio-5999:posicionTestimulo2inicio);
actEspontanea_valores_preE2_C5=x_filt2_C5(posicionTestimulo2inicio-5999:posicionTestimulo2inicio);
subplot(2,2,2)
plot(actEspontanea_tiempos_preE2, actEspontanea_valores_preE2_C5); 
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Actividad espontanea antes del estímulo 2 canal 5 (Capa 5)');
ylim([-0.2 0.1]);

actEspontanea_tiempos_preE3=dt(posicionTestimulo3inicio-5999:posicionTestimulo3inicio);
actEspontanea_valores_preE3_C5=x_filt2_C5(posicionTestimulo3inicio-5999:posicionTestimulo3inicio);
subplot(2,2,3)
plot(actEspontanea_tiempos_preE3, actEspontanea_valores_preE3_C5); 
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Actividad espontanea antes del estímulo 3 canal 5 (Capa 5)');
ylim([-0.2 0.1]);

actEspontanea_tiempos_preE4=dt(posicionTestimulo4inicio-5999:posicionTestimulo4inicio);
actEspontanea_valores_preE4_C5=x_filt2_C5(posicionTestimulo4inicio-5999:posicionTestimulo4inicio);
subplot(2,2,4)
plot(actEspontanea_tiempos_preE4, actEspontanea_valores_preE4_C5); 
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
title('Actividad espontanea antes del estímulo 4 canal 5 (Capa 5)');
ylim([-0.2 0.1]);

%Cálculo amplitudes medias de la actividad espontánea 
%Estímulo 1
tiempos_duracion_espon_preE1_C5=fix(actEspontanea_tiempos_preE1);
amplitud_cada_seg_espon_preE1_C5=[];
segundo=1;
matriz_estimulos_xseg_espon_preE1_C5=[];
columna=1;
posicion=0;
for v2=segundo:11
    for v1=(posicion+2):length(actEspontanea_tiempos_preE1)
        if tiempos_duracion_espon_preE1_C5(v1)==tiempos_duracion_espon_preE1_C5(v1-1)
            matriz_estimulos_xseg_espon_preE1_C5(v2,columna)=actEspontanea_valores_preE1_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_espon_preE1_C5(v2)=peak2peak(matriz_estimulos_xseg_espon_preE1_C5(v2,:));
end
pos_amplitud_ups_espon_preE1_C5=find(amplitud_cada_seg_espon_preE1_C5>0.09);
amplitud_ups_espon_preE1_C5=amplitud_cada_seg_espon_preE1_C5(pos_amplitud_ups_espon_preE1_C5);
media_amplitud_espon_preE1_C5=mean(amplitud_ups_espon_preE1_C5);

%Estímulo 2
tiempos_duracion_espon_preE2_C5=fix(actEspontanea_tiempos_preE2);
amplitud_cada_seg_espon_preE2_C5=[];
segundo=1;
matriz_estimulos_xseg_espon_preE2_C5=[];
columna=1;
posicion=0;
for v2=segundo:11
    for v1=(posicion+2):length(actEspontanea_tiempos_preE2)
        if tiempos_duracion_espon_preE2_C5(v1)==tiempos_duracion_espon_preE2_C5(v1-1)
            matriz_estimulos_xseg_espon_preE2_C5(v2,columna)=actEspontanea_valores_preE2_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_espon_preE2_C5(v2)=peak2peak(matriz_estimulos_xseg_espon_preE2_C5(v2,:));
end
pos_amplitud_ups_espon_preE2_C5=find(amplitud_cada_seg_espon_preE2_C5>0.09);
amplitud_ups_espon_preE2_C5=amplitud_cada_seg_espon_preE2_C5(pos_amplitud_ups_espon_preE2_C5);
media_amplitud_espon_preE2_C5=mean(amplitud_ups_espon_preE2_C5);

%Estímulo 3
tiempos_duracion_espon_preE3_C5=fix(actEspontanea_tiempos_preE3);
amplitud_cada_seg_espon_preE3_C5=[];
segundo=1;
matriz_estimulos_xseg_espon_preE3_C5=[];
columna=1;
posicion=0;
for v2=segundo:11
    for v1=(posicion+2):length(actEspontanea_tiempos_preE3)
        if tiempos_duracion_espon_preE3_C5(v1)==tiempos_duracion_espon_preE3_C5(v1-1)
            matriz_estimulos_xseg_espon_preE3_C5(v2,columna)=actEspontanea_valores_preE3_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_espon_preE3_C5(v2)=peak2peak(matriz_estimulos_xseg_espon_preE3_C5(v2,:));
end
pos_amplitud_ups_espon_preE3_C5=find(amplitud_cada_seg_espon_preE3_C5>0.09);
amplitud_ups_espon_preE3_C5=amplitud_cada_seg_espon_preE3_C5(pos_amplitud_ups_espon_preE3_C5);
media_amplitud_espon_preE3_C5=mean(amplitud_ups_espon_preE3_C5);
 
%Estímulo 4
tiempos_duracion_espon_preE4_C5=fix(actEspontanea_tiempos_preE4);
amplitud_cada_seg_espon_preE4_C5=[];
segundo=1;
matriz_estimulos_xseg_espon_preE4_C5=[];
columna=1;
posicion=0;
for v2=segundo:11
    for v1=(posicion+2):length(actEspontanea_tiempos_preE4)
        if tiempos_duracion_espon_preE4_C5(v1)==tiempos_duracion_espon_preE4_C5(v1-1)
            matriz_estimulos_xseg_espon_preE4_C5(v2,columna)=actEspontanea_valores_preE4_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_espon_preE4_C5(v2)=peak2peak(matriz_estimulos_xseg_espon_preE4_C5(v2,:));
end
pos_amplitud_ups_espon_preE4_C5=find(amplitud_cada_seg_espon_preE4_C5>0.09);
amplitud_ups_espon_preE4_C5=amplitud_cada_seg_espon_preE4_C5(pos_amplitud_ups_espon_preE4_C5);
media_amplitud_espon_preE4_C5=mean(amplitud_ups_espon_preE4_C5);

%% 5. Detección y cálculo de las amplitudes de las activaciones durante el estímulo.
%Se realiza un bucle for para ir viendo las amplitudes en cada segundo del
%canal 5

%Estímulo 1
posicionDown1_C5=find(dt==11.5725);
posicionDown2_C5=find(dt==12.5825);
down_valores_C5=x_filt_C5(posicionDown1_C5:posicionDown2_C5);
down_tiempos=dt(posicionDown1_C5:posicionDown2_C5);
amplitud_media_DOWN=peak2peak(down_valores_C5);
act1_E1_C5=[];
tiempos_duracion_E1_C5=fix(estimulo1_tiempos);
amplitud_cada_seg_E1_C5=[];
segundo=1;
matriz_estimulos_xseg_E1_C5=[];
vector_tiempos_E1_C5=(15:74);
columna=1;
posicion=0;
for v2=segundo:60
    for v1=(posicion+2):length(estimulo1_tiempos)
        if tiempos_duracion_E1_C5(v1)==tiempos_duracion_E1_C5(v1-1)
            matriz_estimulos_xseg_E1_C5(v2,columna)=estimulo1_valores_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_E1_C5(v2)=peak2peak(matriz_estimulos_xseg_E1_C5(v2,:));
end
media_amplitud_E1_C5=mean(amplitud_cada_seg_E1_C5);

for z=1:59
    if amplitud_cada_seg_E1_C5(z)>amplitud_media_DOWN
        act1_E1_C5(z)=1;
    end
end
contador=0;
pos=0;
pos_c=0;
comienzo_actividad_E1_C5=0;
fin_actividad_E1_C5=0;
for x=1:59
    if act1_E1_C5(x)==1 && fin_actividad_E1_C5==0
        contador=contador+1;
        pos=x;
        if contador==7
            pos_c=x-6;
            comienzo_actividad_E1_C5=pos_c;
            for p=x:59
                if act1_E1_C5(p)==0
                    fin_actividad_E1_C5=p;
                    break
                end
            end 
        end
    else
        contador=0;
    end
end
[minimoE1_act_ini,posicionTestimulo1inicio_act_C5]=min(abs(dt-(comienzo_actividad_E1_C5+15)));
[minimoE1_act_fin,posicionTestimulo1fin_act_C5]=min(abs(dt-(fin_actividad_E1_C5+15)));
vector_Activacion_E1_C5_valores=x_filt2_C5(posicionTestimulo1inicio_act_C5:posicionTestimulo1fin_act_C5);
vector_Activacion_E1_C5_tiempos=dt(posicionTestimulo1inicio_act_C5:posicionTestimulo1fin_act_C5);

tiempos_duracion_act_E1_C5=fix(vector_Activacion_E1_C5_tiempos);
amplitud_cada_seg_act_E1_C5=[];
segundo=1;
matriz_estimulos_xseg_act_E1_C5=[];
columna=1;
posicion=0;
for v2=segundo:(fin_actividad_E1_C5-comienzo_actividad_E1_C5)
    for v1=(posicion+3):length(vector_Activacion_E1_C5_tiempos)
        if tiempos_duracion_act_E1_C5(v1)==tiempos_duracion_act_E1_C5(v1-1)
            matriz_estimulos_xseg_act_E1_C5(v2,columna)=vector_Activacion_E1_C5_valores(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_act_E1_C5(v2)=peak2peak(matriz_estimulos_xseg_act_E1_C5(v2,:));
end
media_amplitud_act_E1_C5=mean(amplitud_cada_seg_act_E1_C5);
figure
subplot(2,2,1)
plot(vector_Activacion_E1_C5_tiempos,vector_Activacion_E1_C5_valores);
title('Activación del estímulo 1 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 

%Estímulo 2
act1_E2_C5=[];
tiempos_duracion_E2_C5=fix(estimulo2_tiempos);
amplitud_cada_seg_E2_C5=[];
segundo=1;
matriz_estimulos_xseg_E2_C5=[];
vector_tiempos_E2_C5=(134:194);
columna=1;
posicion=0;
for v2=segundo:60
    for v1=(posicion+2):length(estimulo2_tiempos)
        if tiempos_duracion_E2_C5(v1)==tiempos_duracion_E2_C5(v1-1)
            matriz_estimulos_xseg_E2_C5(v2,columna)=estimulo2_valores_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_E2_C5(v2)=peak2peak(matriz_estimulos_xseg_E2_C5(v2,:));
end
media_amplitud_E2_C5=mean(amplitud_cada_seg_E2_C5);

for z=1:59
    if amplitud_cada_seg_E2_C5(z)>amplitud_media_DOWN
        act1_E2_C5(z)=1;
    end
end
contador=0;
pos=0;
pos_c=0;
comienzo_actividad_E2_C5=0;
fin_actividad_E2_C5=0;
for x=1:59
    if act1_E2_C5(x)==1 && fin_actividad_E2_C5==0
        contador=contador+1;
        pos=x;
        if contador==7
            pos_c=x-6;
            comienzo_actividad_E2_C5=pos_c;
            for p=x:59
                if act1_E2_C5(p)==0
                    fin_actividad_E2_C5=p;
                    break
                end
            end 
        end
    else
        contador=0;
    end
end
[minimoE2_act_ini_C5,posicionTestimulo2inicio_act_C5]=min(abs(dt-(comienzo_actividad_E2_C5+134)));
[minimoE2_act_fin_C5,posicionTestimulo2fin_act_C5]=min(abs(dt-(fin_actividad_E2_C5+134)));
vector_Activacion_E2_C5_valores=x_filt2_C5(posicionTestimulo2inicio_act_C5:posicionTestimulo2fin_act_C5);
vector_Activacion_E2_C5_tiempos=dt(posicionTestimulo2inicio_act_C5:posicionTestimulo2fin_act_C5);
subplot(2,2,2)
plot(vector_Activacion_E2_C5_tiempos,vector_Activacion_E2_C5_valores);
title('Activación del estímulo 2 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 

%Estímulo 3
act1_E3_C5=[];
tiempos_duracion_E3_C5=fix(estimulo3_tiempos);
amplitud_cada_seg_E3_C5=[];
segundo=1;
matriz_estimulos_xseg_E3_C5=[];
vector_tiempos_E3_C5=(269:329);
columna=1;
posicion=0;
for v2=segundo:60
    for v1=(posicion+2):length(estimulo3_tiempos)
        if tiempos_duracion_E3_C5(v1)==tiempos_duracion_E3_C5(v1-1)
            matriz_estimulos_xseg_E3_C5(v2,columna)=estimulo3_valores_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_E3_C5(v2)=peak2peak(matriz_estimulos_xseg_E3_C5(v2,:));
end
media_amplitud_E3_C5=mean(amplitud_cada_seg_E3_C5);

for z=1:59
    if amplitud_cada_seg_E3_C5(z)>amplitud_media_DOWN
        act1_E3_C5(z)=1;
    end
end
contador=0;
pos=0;
pos_c=0;
comienzo_actividad_E3_C5=0;
fin_actividad_E3_C5=0;
for x=1:59
    if act1_E3_C5(x)==1 && fin_actividad_E3_C5==0
        contador=contador+1;
        pos=x;
        if contador==7
            pos_c=x-6;
            comienzo_actividad_E3_C3=pos_c;
            for p=x:59
                if act1_E3_C5(p)==0
                    fin_actividad_E3_C5=p;
                    break
                end
            end 
        end
    else
        contador=0;
    end
end
[minimoE3_act_ini_C5,posicionTestimulo3inicio_act_C5]=min(abs(dt-(comienzo_actividad_E3_C5+270)));
[minimoE3_act_fin_C5,posicionTestimulo3fin_act_C5]=min(abs(dt-(fin_actividad_E3_C5+269)));
vector_Activacion_E3_C5_valores=x_filt2_C5(posicionTestimulo3inicio_act_C5:posicionTestimulo3fin_act_C5);
vector_Activacion_E3_C5_tiempos=dt(posicionTestimulo3inicio_act_C5:posicionTestimulo3fin_act_C5);
subplot(2,2,3)
plot(vector_Activacion_E3_C5_tiempos,vector_Activacion_E3_C5_valores);
title('Activación del estímulo 3 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 

%Estímulo 4
act1_E4_C5=[];
tiempos_duracion_E4_C5=fix(estimulo2_tiempos);
amplitud_cada_seg_E4_C5=[];
segundo=1;
matriz_estimulos_xseg_E4_C5=[];
vector_tiempos_E4_C5=(428:488);
columna=1;
posicion=0;
for v2=segundo:60
    for v1=(posicion+2):length(estimulo2_tiempos)
        if tiempos_duracion_E4_C5(v1)==tiempos_duracion_E4_C5(v1-1)
            matriz_estimulos_xseg_E4_C5(v2,columna)=estimulo4_valores_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_E4_C5(v2)=peak2peak(matriz_estimulos_xseg_E4_C5(v2,:));
end
media_amplitud_E4_C5=mean(amplitud_cada_seg_E4_C5);
mediatotalEstimulos_C5=((media_amplitud_E1_C5+media_amplitud_E2_C5+media_amplitud_E3_C5+media_amplitud_E4_C5)/4);

for z=1:59
    if amplitud_cada_seg_E4_C5(z)>amplitud_media_DOWN
        act1_E4_C5(z)=1;
    end
end
contador=0;
pos=0;
pos_c=0;
comienzo_actividad_E4_C5=0;
fin_actividad_E4_C5=0;
for x=1:59
    if act1_E4_C5(x)==1 && fin_actividad_E4_C5==0
        contador=contador+1;
        pos=x;
        if contador==8
            pos_c=x-7;
            comienzo_actividad_E4_C5=pos_c;
            for p=x:59
                if act1_E4_C5(p)==0
                    fin_actividad_E4_C5=p;
                    break
                end
            end 
        end
    else
        contador=0;
    end
end
[minimoE4_act_ini_C5,posicionTestimulo4inicio_act_C5]=min(abs(dt-(comienzo_actividad_E4_C5+428)));
[minimoE4_act_fin_C5,posicionTestimulo4fin_act_C5]=min(abs(dt-(fin_actividad_E4_C5+428)));
vector_Activacion_E4_C5_valores=x_filt2_C5(posicionTestimulo4inicio_act_C5:posicionTestimulo4fin_act_C5);
vector_Activacion_E4_C5_tiempos=dt(posicionTestimulo4inicio_act_C5:posicionTestimulo4fin_act_C5);
subplot(2,2,4)
plot(vector_Activacion_E4_C5_tiempos,vector_Activacion_E4_C5_valores);
title('Activación del estímulo 4 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 

%% 6. Detección del principio del estímulo y cálculo de la amplitud del principio del estímulo
%Canal 5
%Estímulo 1
vector_valores_preAct_E1_C5=x_filt2_C5(posicionTestimulo1inicio:posicionTestimulo1inicio_act_C5);
vector_tiempos_preAct_E1_C5=dt(posicionTestimulo1inicio:posicionTestimulo1inicio_act_C5);
tiempos_duracion_preAct_E1_C5=fix(vector_tiempos_preAct_E1_C5);
amplitud_cada_seg_preAct_E1_C5=[];
segundo=1;
matriz_estimulos_xseg_preAct_E1_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_preAct_E1_C5(end)-tiempos_duracion_preAct_E1_C5(1))
    for v1=(posicion+3):length(vector_tiempos_preAct_E1_C5)
        if tiempos_duracion_preAct_E1_C5(v1)==tiempos_duracion_preAct_E1_C5(v1-1)
            matriz_estimulos_xseg_preAct_E1_C5(v2,columna)=vector_valores_preAct_E1_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_preAct_E1_C5(v2)=peak2peak(matriz_estimulos_xseg_preAct_E1_C5(v2,:));
end
pos_amplitud_ups_principio_preE1_C5=find(amplitud_cada_seg_preAct_E1_C5>0.09);
amplitud_ups_principio_preE1_C5=amplitud_cada_seg_preAct_E1_C5(pos_amplitud_ups_principio_preE1_C5);
media_amplitud_principio_preE1_C5=mean(amplitud_ups_principio_preE1_C5);

 
%Estímulo 2
vector_valores_preAct_E2_C5=x_filt2_C5(posicionTestimulo2inicio:posicionTestimulo2inicio_act_C5);
vector_tiempos_preAct_E2_C5=dt(posicionTestimulo2inicio:posicionTestimulo2inicio_act_C5);
tiempos_duracion_preAct_E2_C5=fix(vector_tiempos_preAct_E2_C5);
amplitud_cada_seg_preAct_E2_C5=[];
segundo=1;
matriz_estimulos_xseg_preAct_E2_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_preAct_E2_C5(end)-tiempos_duracion_preAct_E2_C5(1))
    for v1=(posicion+3):length(vector_tiempos_preAct_E2_C5)
        if tiempos_duracion_preAct_E2_C5(v1)==tiempos_duracion_preAct_E2_C5(v1-1)
            matriz_estimulos_xseg_preAct_E2_C5(v2,columna)=vector_valores_preAct_E2_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_preAct_E2_C5(v2)=peak2peak(matriz_estimulos_xseg_preAct_E2_C5(v2,:));
end
pos_amplitud_ups_principio_preE2_C5=find(amplitud_cada_seg_preAct_E2_C5>0.09);
amplitud_ups_principio_preE2_C5=amplitud_cada_seg_preAct_E2_C5(pos_amplitud_ups_principio_preE2_C5);
media_amplitud_principio_preE2_C5=mean(amplitud_ups_principio_preE2_C5);

%Estímulo 3
vector_valores_preAct_E3_C5=x_filt2_C5(posicionTestimulo3inicio:posicionTestimulo3inicio_act_C5);
vector_tiempos_preAct_E3_C5=dt(posicionTestimulo3inicio:posicionTestimulo3inicio_act_C5);
tiempos_duracion_preAct_E3_C5=fix(vector_tiempos_preAct_E3_C5);
amplitud_cada_seg_preAct_E3_C5=[];
segundo=1;
matriz_estimulos_xseg_preAct_E3_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_preAct_E3_C5(end)-tiempos_duracion_preAct_E3_C5(1))
    for v1=(posicion+3):length(vector_tiempos_preAct_E3_C5)
        if tiempos_duracion_preAct_E3_C5(v1)==tiempos_duracion_preAct_E3_C5(v1-1)
            matriz_estimulos_xseg_preAct_E3_C5(v2,columna)=vector_valores_preAct_E3_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_preAct_E3_C5(v2)=peak2peak(matriz_estimulos_xseg_preAct_E3_C5(v2,:));
end
pos_amplitud_ups_principio_preE3_C5=find(amplitud_cada_seg_preAct_E3_C5>0.09);
amplitud_ups_principio_preE3_C5=amplitud_cada_seg_preAct_E3_C5(pos_amplitud_ups_principio_preE3_C5);
media_amplitud_principio_preE3_C5=mean(amplitud_ups_principio_preE3_C5);

%Estímulo 4
vector_valores_preAct_E4_C5=x_filt2_C5(posicionTestimulo4inicio:posicionTestimulo4inicio_act_C5);
vector_tiempos_preAct_E4_C5=dt(posicionTestimulo4inicio:posicionTestimulo4inicio_act_C5);
tiempos_duracion_preAct_E4_C5=fix(vector_tiempos_preAct_E4_C5);
amplitud_cada_seg_preAct_E4_C5=[];
segundo=1;
matriz_estimulos_xseg_preAct_E4_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_preAct_E4_C5(end)-tiempos_duracion_preAct_E4_C5(1))
    for v1=(posicion+3):length(vector_tiempos_preAct_E4_C5)
        if tiempos_duracion_preAct_E4_C5(v1)==tiempos_duracion_preAct_E4_C5(v1-1)
            matriz_estimulos_xseg_preAct_E4_C5(v2,columna)=vector_valores_preAct_E4_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_preAct_E4_C5(v2)=peak2peak(matriz_estimulos_xseg_preAct_E4_C5(v2,:));
end
pos_amplitud_ups_principio_preE4_C5=find(amplitud_cada_seg_preAct_E4_C5>0.09);
amplitud_ups_principio_preE4_C5=amplitud_cada_seg_preAct_E4_C5(pos_amplitud_ups_principio_preE4_C5);
media_amplitud_principio_preE4_C5=mean(amplitud_ups_principio_preE4_C5);

figure
subplot(2,2,1)
plot(vector_tiempos_preAct_E1_C5,vector_valores_preAct_E1_C5);
title('Actividad espontánea dedse el comienzo del estímulo 1 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
subplot(2,2,2)
plot(vector_tiempos_preAct_E2_C5,vector_valores_preAct_E2_C5);
title('ctividad espontánea dedse el comienzo del estímulo 2 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
subplot(2,2,3)
plot(vector_tiempos_preAct_E3_C5,vector_valores_preAct_E3_C5);
title('ctividad espontánea dedse el comienzo del estímulo 3 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 
subplot(2,2,4)
plot(vector_tiempos_preAct_E4_C5,vector_valores_preAct_E4_C5);
title('ctividad espontánea dedse el comienzo del estímulo 4 del canal 5 (Capa 5)');
xlabel ( 'Tiempo (s)' );
ylabel ( 'Voltaje (mV)' ); 

%% 7. Cálculo Amplitud de cada activacion del estímulo

%Canal 5
%Estímulo 1
tiempos_duracion_act_E1_C5=fix(vector_Activacion_E1_C5_tiempos);
amplitud_cada_seg_act_E1_C5=[];
segundo=1;
matriz_estimulos_xseg_act_E1_C5=[];
columna=1;
posicion=0;
for v2=segundo:(fin_actividad_E1_C5-comienzo_actividad_E1_C5)
    for v1=(posicion+3):length(vector_Activacion_E1_C5_tiempos)
        if tiempos_duracion_act_E1_C5(v1)==tiempos_duracion_act_E1_C5(v1-1)
            matriz_estimulos_xseg_act_E1_C5(v2,columna)=vector_Activacion_E1_C5_valores(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_act_E1_C5(v2)=peak2peak(matriz_estimulos_xseg_act_E1_C5(v2,:));
end
pos_amplitud_ups_act_preE1_C5=find(amplitud_cada_seg_act_E1_C5>0.07);
amplitud_ups_act_preE1_C5=amplitud_cada_seg_act_E1_C5(pos_amplitud_ups_act_preE1_C5);
media_amplitud_act_preE1_C5=mean(amplitud_ups_act_preE1_C5);

%Estímulo 2
tiempos_duracion_act_E2_C5=fix(vector_Activacion_E2_C5_tiempos);
amplitud_cada_seg_act_E2_C5=[];
segundo=1;
matriz_estimulos_xseg_act_E2_C5=[];
columna=1;
posicion=0;
for v2=segundo:(fin_actividad_E2_C5-comienzo_actividad_E2_C5)
    for v1=(posicion+3):length(vector_Activacion_E2_C5_tiempos)
        if tiempos_duracion_act_E2_C5(v1)==tiempos_duracion_act_E2_C5(v1-1)
            matriz_estimulos_xseg_act_E2_C5(v2,columna)=vector_Activacion_E2_C5_valores(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_act_E2_C5(v2)=peak2peak(matriz_estimulos_xseg_act_E2_C5(v2,:));
end
pos_amplitud_ups_act_preE2_C5=find(amplitud_cada_seg_act_E2_C5>0.07);
amplitud_ups_act_preE2_C5=amplitud_cada_seg_act_E2_C5(pos_amplitud_ups_act_preE2_C5);
media_amplitud_act_preE2_C5=mean(amplitud_ups_act_preE2_C5);

%Estímulo 3
tiempos_duracion_act_E3_C5=fix(vector_Activacion_E3_C5_tiempos);
amplitud_cada_seg_act_E3_C5=[];
segundo=1;
matriz_estimulos_xseg_act_E3_C5=[];
columna=1;
posicion=0;
for v2=segundo:(fin_actividad_E3_C5-comienzo_actividad_E3_C5-2)
    for v1=(posicion+3):length(vector_Activacion_E3_C5_tiempos)
        if tiempos_duracion_act_E3_C5(v1)==tiempos_duracion_act_E3_C5(v1-1)
            matriz_estimulos_xseg_act_E3_C5(v2,columna)=vector_Activacion_E3_C5_valores(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_act_E3_C5(v2)=peak2peak(matriz_estimulos_xseg_act_E3_C5(v2,:));
end
pos_amplitud_ups_act_preE3_C5=find(amplitud_cada_seg_act_E3_C5>0.07);
amplitud_ups_act_preE3_C5=amplitud_cada_seg_act_E3_C5(pos_amplitud_ups_act_preE3_C5);
media_amplitud_act_preE3_C5=mean(amplitud_ups_act_preE3_C5);

%Estímulo 4
tiempos_duracion_act_E4_C5=fix(vector_Activacion_E4_C5_tiempos);
amplitud_cada_seg_act_E4_C5=[];
segundo=1;
matriz_estimulos_xseg_act_E4_C5=[];
columna=1;
posicion=0;
for v2=segundo:(fin_actividad_E4_C5-comienzo_actividad_E4_C5)
    for v1=(posicion+3):length(vector_Activacion_E4_C5_tiempos)
        if tiempos_duracion_act_E4_C5(v1)==tiempos_duracion_act_E4_C5(v1-1)
            matriz_estimulos_xseg_act_E4_C5(v2,columna)=vector_Activacion_E4_C5_valores(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_act_E4_C5(v2)=peak2peak(matriz_estimulos_xseg_act_E4_C5(v2,:));
end
pos_amplitud_ups_act_preE4_C5=find(amplitud_cada_seg_act_E4_C5>0.07);
amplitud_ups_act_preE4_C5=amplitud_cada_seg_act_E4_C5(pos_amplitud_ups_act_preE4_C5);
media_amplitud_act_preE4_C5=mean(amplitud_ups_act_preE4_C5);
 

%% 8. Detección del post-estímulo y cálculo de la amplitud del post-estímulo
%Canal 5
%Estímulo 1
vector_valores_postAct_E1_C5=x_filt2_C5(posicionTestimulo1fin_act_C5:posicionTestimulo1inicio+24000);
vector_tiempos_postAct_E1_C5=dt(posicionTestimulo1fin_act_C5:posicionTestimulo1inicio+24000);
tiempos_duracion_postAct_E1_C5=fix(vector_tiempos_postAct_E1_C5);
amplitud_cada_seg_postAct_E1_C5=[];
segundo=1;
matriz_estimulos_xseg_postAct_E1_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_postAct_E1_C5(end)-tiempos_duracion_postAct_E1_C5(1))
    for v1=(posicion+3):length(vector_tiempos_postAct_E1_C5)
        if tiempos_duracion_postAct_E1_C5(v1)==tiempos_duracion_postAct_E1_C5(v1-1)
            matriz_estimulos_xseg_postAct_E1_C5(v2,columna)=vector_valores_postAct_E1_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_postAct_E1_C5(v2)=peak2peak(matriz_estimulos_xseg_postAct_E1_C5(v2,:));
end
pos_amplitud_ups_postAct_E1_C5=find(amplitud_cada_seg_postAct_E1_C5>0.09);
amplitud_ups_postAct_E1_C5=amplitud_cada_seg_postAct_E1_C5(pos_amplitud_ups_postAct_E1_C5);
media_amplitud_postAct_E1_C5=mean(amplitud_ups_postAct_E1_C5);

%Estímulo 2
vector_valores_postAct_E2_C5=x_filt2_C5(posicionTestimulo2fin_act_C5:posicionTestimulo2inicio+24000);
vector_tiempos_postAct_E2_C5=dt(posicionTestimulo2fin_act_C5:posicionTestimulo2inicio+24000);
tiempos_duracion_postAct_E2_C5=fix(vector_tiempos_postAct_E2_C5);
amplitud_cada_seg_postAct_E2_C5=[];
segundo=1;
matriz_estimulos_xseg_postAct_E2_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_postAct_E2_C5(end)-tiempos_duracion_postAct_E2_C5(1))
    for v1=(posicion+3):length(vector_tiempos_postAct_E2_C5)
        if tiempos_duracion_postAct_E2_C5(v1)==tiempos_duracion_postAct_E2_C5(v1-1)
            matriz_estimulos_xseg_postAct_E2_C5(v2,columna)=vector_valores_postAct_E2_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_postAct_E2_C5(v2)=peak2peak(matriz_estimulos_xseg_postAct_E2_C5(v2,:));
end
pos_amplitud_ups_postAct_E2_C5=find(amplitud_cada_seg_postAct_E2_C5>0.09);
amplitud_ups_postAct_E2_C5=amplitud_cada_seg_postAct_E2_C5(pos_amplitud_ups_postAct_E2_C5);
media_amplitud_postAct_E2_C5=mean(amplitud_ups_postAct_E2_C5);

%Estímulo 3
vector_valores_postAct_E3_C5=x_filt2_C5(posicionTestimulo3fin_act_C5:posicionTestimulo3inicio+24000);
vector_tiempos_postAct_E3_C5=dt(posicionTestimulo3fin_act_C5:posicionTestimulo3inicio+24000);
tiempos_duracion_postAct_E3_C5=fix(vector_tiempos_postAct_E3_C5);
amplitud_cada_seg_postAct_E3_C5=[];
segundo=1;
matriz_estimulos_xseg_postAct_E3_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_postAct_E3_C5(end)-tiempos_duracion_postAct_E3_C5(1))
    for v1=(posicion+3):length(vector_tiempos_postAct_E3_C5)
        if tiempos_duracion_postAct_E3_C5(v1)==tiempos_duracion_postAct_E3_C5(v1-1)
            matriz_estimulos_xseg_postAct_E3_C5(v2,columna)=vector_valores_postAct_E3_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_postAct_E3_C5(v2)=peak2peak(matriz_estimulos_xseg_postAct_E3_C5(v2,:));
end
pos_amplitud_ups_postAct_E3_C5=find(amplitud_cada_seg_postAct_E3_C5>0.09);
amplitud_ups_postAct_E3_C5=amplitud_cada_seg_postAct_E3_C5(pos_amplitud_ups_postAct_E3_C5);
media_amplitud_postAct_E3_C5=mean(amplitud_ups_postAct_E3_C5);

%Estímulo 4
vector_valores_postAct_E4_C5=x_filt2_C5(posicionTestimulo4fin_act_C5:posicionTestimulo4inicio+24000);
vector_tiempos_postAct_E4_C5=dt(posicionTestimulo4fin_act_C5:posicionTestimulo4inicio+24000);
tiempos_duracion_postAct_E4_C5=fix(vector_tiempos_postAct_E4_C5);
amplitud_cada_seg_postAct_E4_C5=[];
segundo=1;
matriz_estimulos_xseg_postAct_E4_C5=[];
columna=1;
posicion=0;
for v2=segundo:(tiempos_duracion_postAct_E4_C5(end)-tiempos_duracion_postAct_E4_C5(1))
    for v1=(posicion+3):length(vector_tiempos_postAct_E4_C5)
        if tiempos_duracion_postAct_E4_C5(v1)==tiempos_duracion_postAct_E4_C5(v1-1)
            matriz_estimulos_xseg_postAct_E4_C5(v2,columna)=vector_valores_postAct_E4_C5(v1-1);
            columna=columna+1;
            posicion=v1;
        else
            columna=1;
            break
        end
    end
    amplitud_cada_seg_postAct_E4_C5(v2)=peak2peak(matriz_estimulos_xseg_postAct_E4_C5(v2,:));
end
pos_amplitud_ups_postAct_E4_C5=find(amplitud_cada_seg_postAct_E4_C5>0.09);
amplitud_ups_postAct_E4_C5=amplitud_cada_seg_postAct_E4_C5(pos_amplitud_ups_postAct_E4_C5);
media_amplitud_postAct_E4_C5=mean(amplitud_ups_postAct_E4_C5);

figure
subplot(4,1,1)
plot(vector_tiempos_postAct_E1_C5,vector_valores_postAct_E1_C5);
title('Post-estímulo 1 canal 5 (capa 5)');
subplot(4,1,2)
plot(vector_tiempos_postAct_E2_C5,vector_valores_postAct_E2_C5);
title('Post-estímulo 2 canal 5 (capa 5)');
subplot(4,1,3)
plot(vector_tiempos_postAct_E3_C5,vector_valores_postAct_E3_C5);
title('Post-estímulo 3 canal 5 (capa 5)');
subplot(4,1,4)
plot(vector_tiempos_postAct_E4_C5,vector_valores_postAct_E4_C5);
title('Post-estímulo 4 canal 5 (capa 5)');


%% 9. Cálculo y representación del espectograma
SNR=90;
nfft=fs*2;
window=hann(nfft);
figure
spectrogram(canal5_s_E1,window,[],nfft,fs,'MinThreshold',-SNR,'yaxis'); 
title('Espectrograma del estímulo 1 del canal 5 (capa 5) de 0-40Hz');
ylim([0 40]);