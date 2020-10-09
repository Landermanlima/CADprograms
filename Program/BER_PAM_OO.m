clear all;
clc;
close all;


nbits_max=10^6; %nr total de bits a serem transmitidos na simulacao
nerr_max=100; %nr total de erros para parar a simulacao

EBN0db_v=(0:1:13); %vetor de EB/N0 em dB a ser simulado
BER_v=zeros(length(EBN0db_v),1); %vetor de valores de BER
teoBER_v=BER_v; %vetor com os valores analiticos da BER

for ii=1:length(EBN0db_v)
    
    EBN0db=EBN0db_v(ii);
    disp(['iniciando EB/N0 = ' int2str(EBN0db) 'dB'] );
    
    EBN0=10^(EBN0db/10);
    %obs - considerando Eb=1, N0=1/EBN0
    N0=1/EBN0;
    sigma2=N0/2;
    
    nerr=0; nbits=0;
    while nerr<=nerr_max || nbits<=nbits_max
        
        bits_v=randi(2,1000,1)-1; %vetor de bits (0/1) a ser transmitido
        signal_v=sqrt(2)*bits_v; %Sinal modulado - constelacao PAM On-Off
        n_v=sqrt(sigma2)*randn(1000,1); %vetor de amostras de ruido AWGN
        rsig_v=signal_v+n_v;
        
        rbits_v=(sign(rsig_v-0.5*sqrt(2))+1)/2; %decisor de limiar l=sqrt(2)/2
        
        nbits=nbits+1000; %atualiza o nr de bits transmitido
        nerr=nerr+sum(abs(bits_v-rbits_v)); %atualiza o nr de erros
       
    end
    BER_v(ii,1)=nerr/nbits; %estimativa real
    teoBER_v(ii,1)=qfunc(sqrt(EBN0)); %estimativa teorica 
end

figure(1);
semilogy(EBN0db_v,BER_v,'b+-');
hold on;
semilogy(EBN0db_v,teoBER_v,'ro:');
xlabel('EB/N0 (dB)');
ylabel('BER');
legend('Simulacao Monte Carlo','Valor analitico');
grid();
