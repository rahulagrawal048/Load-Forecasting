temp=xlsread('loadData.xls','ISONE CA','M:M');
hum=xlsread('loadData.xls','ISONE CA','N:N');
t=readfis('tempFis2');
h=readfis('humFis2');
changeTemp=zeros(8736,1);
changeHum=zeros(8736,1);
for k=1:8736
    out1=evalfis([temp(k) temp(k+24)],t);
    changeTemp(k,1)=out1;
    out2=evalfis([hum(k) hum(k+24)],h);
    changeHum(k,1)=out2;
end
