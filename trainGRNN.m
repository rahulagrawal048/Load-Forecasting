
demand=xlsread('loadData.xls','D:D');
hour=xlsread('loadData.xls','B:B');
daynumber=xlsread('loadData.xls','Q:Q');
%load('changeTemp');
%load('changeHum');
prevLoad=zeros(8736,1);
afterLoad=zeros(8736,1);
for k=1:8736
    prevLoad(k,1)=demand(k,1);
end
m=1;
for k=25:8760
    afterLoad(m,1)=demand(k,1);
    m=m+1;
end
p=1;
pt=1;
for k=1:11
for i=720*(k-1)+1:720*(k-1)+360
    P1(p,1)=changeTemp(i,1);
    P2(p,1)=changeHum(i,1);
    P3(p,1)=prevLoad(i,1);
    Y(p,1)=afterLoad(i,1);
    p=p+1;
end
for i=720*(k-1)+361:720*(k-1)+720
    P_test1(pt,1)=changeTemp(i,1);
    P_test2(pt,1)=changeHum(i,1);
    P_test3(pt,1)=prevLoad(i,1);
    Y_test(pt,1)=afterLoad(i,1);
    pt=pt+1;
end
end 

%for k=12:29
 for i=7921:8328
    P1(p,1)=changeTemp(i,1);
    P2(p,1)=changeHum(i,1);
    P3(p,1)=prevLoad(i,1);
    Y(p,1)=afterLoad(i,1);
    p=p+1;
 end
 for i=8329:8736
    P_test1(pt,1)=changeTemp(i,1);
    P_test2(pt,1)=changeHum(i,1);
    P_test3(pt,1)=prevLoad(i,1);
    Y_test(pt,1)=afterLoad(i,1);
    pt=pt+1;
 end
for k=1:4368
    P4(k,1)=hour(k,1);
end
x=1;    
for k=4369:8736
    P_test4(x,1)=hour(k,1);
    x=x+1;
end
for k=1:4368
    P5(k,1)=daynumber(k,1);
end
x=1;    
for k=4369:8736
    P_test5(x,1)=daynumber(k,1);
    x=x+1;
end
P=horzcat(P1,P2,P3,P4,P5).';
P_test=horzcat(P_test1,P_test2,P_test3,P_test4,P_test5).';
Y=Y.';
Y_test=Y_test.';

nn = [5 30 30 1];
dIn = [0];
dIntern=[];
dOut=[];
net = CreateNN(nn,dIn,dIntern,dOut);

netBFGS = train_BFGS(P,Y,net,1000,1e-5);
y_BFGS = NNOut(P,netBFGS);
ytest_BFGS = NNOut(P_test,netBFGS);

t = (1:4368.0)./4; %480 timesteps in 15 Minute resolution

fig = figure();
set(fig, 'Units', 'normalized', 'Position', [0.2, 0.1, 0.6, 0.6])

subplot(221)
title('Test Data')
set(gca,'FontSize',16)
plot(t,Y(1,:),'r:','LineWidth',2)
hold on
grid on
%plot(t,y_LM(1,:),'b','LineWidth',2)
plot(t,y_BFGS(1,:),'g','LineWidth',2)
l1 = legend('Train Data','LM output','BFGS output','Location','northoutside','Orientation','horizontal');
set(l1,'FontSize',14)
ylabel('Storage Pressure [bar]')
axis tight

%subplot(223)
set(gca,'FontSize',16)
%plot(t,Y(2,:),'r:','LineWidth',2)
%hold on
%grid on
%plot(t,y_LM(2,:),'b','LineWidth',2)
%plot(t,y_BFGS(2,:),'g','LineWidth',2)
%ylabel('el. Power [kW]')
%xlabel('time [h]')
%axis tight

t1=(1:4368.0)./4;
subplot(222)
title('Train Data')
set(gca,'FontSize',16)
plot(t,Y_test(1,:),'r:','LineWidth',2)
hold on
grid on
%plot(t,ytest_LM(1,:),'b','LineWidth',2)
plot(t,ytest_BFGS(1,:),'g','LineWidth',2)
l2 = legend('Test Data','LM output','BFGS output','Location','northoutside','Orientation','horizontal');
set(l2,'FontSize',14)
axis tight

%subplot(224)
%set(gca,'FontSize',16)
%plot(t,Y_test(2,:),'r:','LineWidth',2)
%hold on
%grid on
%plot(t,ytest_LM(2,:),'b','LineWidth',2)
%plot(t,ytest_BFGS(2,:),'g','LineWidth',2)
xlabel('time [h]')
axis tight
