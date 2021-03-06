function [LLR,P]=computePandLLR_6ReferenceVoltages(x,sigma,points)   
% clc
% clear all

% Calculate the probability and LLR value required for LDPC decoding when
% placing 6 read voltages.

% Reference:
%   [1]"CooECC: A Cooperative Error Cprrection Scheme to Reduce LDPC Decoding Latency in NANA Flash"

syms X;

% MLC NAND channel model
mu=[-3 -1 1 3];
for i=1:4
    f(i)=Gauss(mu(i),sigma,X);
end

n=length(x);
plsb0=zeros(1,n);
plsb1=zeros(1,n);
pmsb0=zeros(1,n);
pmsb1=zeros(1,n);

seg{1,1}=[-inf,points(1)];
seg{1,2}=[points(1),points(2)];
seg{1,3}=[points(2),points(3)];
seg{1,4}=[points(3),points(4)];
seg{1,5}=[points(4),points(5)];
seg{1,6}=[points(5),points(6)];
seg{1,7}=[points(6),inf];

for i=1:length(seg)  %  6 reference voltages, 7 parts
    plsb0(i)=int(f(1)+f(2),X,seg{1,i}); 
    plsb1(i)=int(f(3)+f(4),X,seg{1,i});
    pmsb0(i)=int(f(1)+f(4),X,seg{1,i});
    pmsb1(i)=int(f(2)+f(3),X,seg{1,i});
end

P0_LSB=zeros(1,n);
P1_LSB=zeros(1,n);
P0_MSB=zeros(1,n);
P1_MSB=zeros(1,n);
j=1;
for i=1:length(x)
    if x(i)<seg{1}(2)        %        1
        P0_LSB(j)=plsb0(1);
        P1_LSB(j)=plsb1(1);
        P0_MSB(j)=pmsb0(1);
        P1_MSB(j)=pmsb1(1);
    elseif x(i)>=seg{2}(1)&&x(i)<seg{2}(2)        %       2
        P0_LSB(j)=plsb0(2);
        P1_LSB(j)=plsb1(2);
        P0_MSB(j)=pmsb0(2);
        P1_MSB(j)=pmsb1(2);
    elseif x(i)>=seg{3}(1)&&x(i)<seg{3}(2)           %        3
        P0_LSB(j)=plsb0(3);
        P1_LSB(j)=plsb1(3);
        P0_MSB(j)=pmsb0(3);
        P1_MSB(j)=pmsb1(3);
    elseif x(i)>=seg{4}(1)&&x(i)<seg{4}(2)          %       4
        P0_LSB(j)=plsb0(4);
        P1_LSB(j)=plsb1(4);
        P0_MSB(j)=pmsb0(4);
        P1_MSB(j)=pmsb1(4);
    elseif x(i)>=seg{5}(1)&&x(i)<seg{5}(2)         %       5
        P0_LSB(j)=plsb0(5);
        P1_LSB(j)=plsb1(5);
        P0_MSB(j)=pmsb0(5);
        P1_MSB(j)=pmsb1(5);
    elseif x(i)>=seg{6}(1)&&x(i)<seg{6}(2)         %       6
        P0_LSB(j)=plsb0(6);
        P1_LSB(j)=plsb1(6);
        P0_MSB(j)=pmsb0(6);
        P1_MSB(j)=pmsb1(6);
    elseif x(i)>=seg{7}(1)     %       7
        P0_LSB(j)=plsb0(7);
        P1_LSB(j)=plsb1(7);
        P0_MSB(j)=pmsb0(7);
        P1_MSB(j)=pmsb1(7);
    end
    j=j+1;
end

LLR_LSB=log(P0_LSB./P1_LSB);  % Reference [1], page 3.
LLR_MSB=log(P0_MSB./P1_MSB);

LLR=[LLR_LSB;LLR_MSB];
P=[P0_LSB; P1_LSB; P0_MSB; P1_MSB];

