clear; clc;

clear;clc;
nl=1; 

ds=0.1;                                        
x=(-5:ds:5); y=(-5:ds:5);    z=(-3:ds:5);               
Lx=length(x); Ly=length(y); Lz=length(z);       
rw=0.1;                                         
Icurr=30;                                          
mo=4*pi*1e-7;                                     
km=mo*Icurr/(4*pi);                                 
                                                
cp=find(x<=0); cx=cp(1);
cp=find(y<=0); cy=cp(1);                        
cp=find(z<=0); cz=cp(1);

N=12;                       
R=1.5;                                         
sz=1;                   

cp=find(z>=-nl*sz*0.5);  cz=cp(1);      

s=1;    

    dtheta=2*pi/N;                 
    dl=R*dtheta;                   
    ang=(0:dtheta:2*pi-dtheta);    

for I=1:nl                           

    Px(s:s+N-1)=R*cos(ang);           
    Py(s:s+N-1)=R*sin(ang);           
    
   
    Pz(s:s+N-1)=-nl/2*sz+(I-1)*sz;    

   

    dx(s:s+N-1)=-Py(s:s+N-1)*dtheta;  
    dy(s:s+N-1)=Px(s:s+N-1)*dtheta;   

    s=s+N;                            
end

dz(1:N*nl)=0;                     

subplot(3,3,1)
hold on
 %VERTICAL ORIENTED   
    quiver3(Px,Py,Pz,dx,dy,dz,0.5,'-r','LineWidth',3)
    plot3(Px,Py,Pz,'*k','LineWidth',5)
    plot3(Px,Py,Pz,'-k','LineWidth',.3)
   
 xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title 'Curent elements'
    legend('Discrete current elements','Current element location','Loop/Solenoid')
axis([-3 3 -3 3 -3 3])
    grid on
    view(-34,33)

dBx(1:Lx,1:Ly,1:Lz)=0; dBy=dBx; dBz=dBx;   

tic
for I=1:Lx
    for J=1:Ly                  
        for K=1:Lz

            for L=1:nl*N        

            rx=x(I)-Px(L);      
            ry=y(J)-Py(L);      
            rz=z(K)-Pz(L);      
            
            r=sqrt(rx^2+ry^2+rz^2+rw^2);    
            r3=r^3;                         

            dBx(I,J,K)=dBx(I,J,K)+km*dy(L)*rz/r3;
            dBy(I,J,K)=dBy(I,J,K)+km*dx(L)*rz/r3;
            dBz(I,J,K)=dBz(I,J,K)+km*(dx(L)*ry-dy(L)*rx)/r3;

            end

        end
    end
end
toc

%%Plots

Bmag=sqrt(dBx.^2+dBy.^2+dBz.^2);    

centery=round(Ly/2);            
Bx_xz=squeeze(dBx(:,centery,:));   
Bz_xz=squeeze(dBz(:,centery,:));    

Bxz=squeeze(Bmag(:,centery,:));    

subplot(3,3,2)


hold on

pcolor(x,z,(Bxz').^(1/3)); shading interp; colormap jet; colorbar

h1=streamslice(x,z,Bx_xz',Bz_xz',1);
set(h1,'Color', [0.8 1 0.9]);
xlabel 'x'
ylabel 'z'
title 'Magnetic field of a circular current'

%-----------------------------------------------------------------------%%
%-----------------------------------------------------------------------%%
%-------------------------Dipole Falling--------------------------------%%
%-----------------------------------------------------------------------%%
%-----------------------------------------------------------------------%%

mag=10000;                  %Magnetic moment of the magnet
%m=0.005;
m=0.005;

w=m*-9.81;      %Magnet´s mass in kg, and weigth in N
zo=5;                   %Magnet's initial position

dt=0.05;                 %Time step

zm(1)=zo;               %magnet position
zmfree(1)=zo;           %magnet position (free fall case)
tt(1)=0;                %time initialization
vz(1)=0;                %magnet initial velocity
vzfree(1)=0;            %magnet initial velocity (free fall case)
cc=1;                   %index counter

path=animatedline('linewidth', 2, 'linestyle', ':', 'color', 'r');

while zm(cc)>-3
    addpoints(path,0,zm(cc));
    drawnow
    head=scatter(0,zm(cc), 100,'filled'); 

    %signo=zm(cc)/(abs(zm(cc)));

    Fm(cc)=(6*mo*Icurr*R^2*mag*(zm(cc)))/(4*((zm(cc))^2+R^2)^(5/2));    
    F(cc)=Fm(cc)+w; 
    a=F(cc)/m;      
    pause(0.01)

    if zm(cc)>-2.9
    
     zm(cc+1)=zm(cc)+vz(cc)*dt+0.5*a*dt*dt;    
     
     zmfree(cc+1)=zmfree(cc)+vzfree(cc)*dt-0.5*9.81*dt*dt;    
    
        vz(cc+1)=(zm(cc+1)-zm(cc))/dt;       
        vzfree(cc+1)=(zmfree(cc+1)-zmfree(cc))/dt;  
    
        cc=cc+1;                    %counter increase
    
        delete(head)
    end

end

subplot(3,3,3)

hold on
plot(zm(1:length(Fm)),1000*Fm, '-b', 'LineWidth', 2)
plot([0,0],[-0.15,0.15],'-.k','LineWidth', 2)
grid on
xlabel 'z position (m)'
ylabel 'Magnetic force (mN)'
title 'Magnetic force of a Current ring over a falling magnet'
legend('Magnetic force in the Z direction','Current loop location','Location','southeast')

subplot(3,3,4)

hold on
tt=0:dt:(cc-1)*dt;
plot(tt,zm,'-r', 'LineWidth', 2)
plot(tt,zmfree,'--b', 'LineWidth', 2) %Free fall case plot
plot([0,1.8],[0,0],'-.k','LineWidth', 2)
grid on
xlabel 'time (s)'
ylabel 'z position (m)'
title 'Position vs time of a Magnetic dipole falling throug a current ring'
legend('Fall over a current ring','Free fall (no Magnetic force)', 'Current loop location','Location','southwest')
axis([0 1.8 -6 6])

% Etapa 3
% Definir m, u, zo, Rring, dt, ds
m = 5000;

zo = 0.5;
R = 1;
dt = 0.01;
ds = 0.01;

E(1) = 0;
cc = 1;
z(1) = zo;
vz(1) = 0;
g = -9.81;
[Bz(:,:,cc),phi(cc),x,y] = B_due_m(m,z(cc),R,ds);
while z(cc) >= -zo
    pause(0.1);
    %I(1) = E(1) / resistencia; -> parte 3
    % Llamar código step 2, dividir voltaje entre resistencia del anillo,
    % esa corriente la meto
    % [deltaZ * step2(I(cc),R, u, z(c))]; z(c+1) = z(c) + deltaZ;

    z(cc+1) = z(cc) + (vz(cc) * dt) + ((1/2) * g * dt^2);

    [Bz(:,:,cc+1),phi(cc+1),x,y] = B_due_m(m,z(cc+1),R,ds);

    E(cc+1) = (phi(cc+1) - phi(cc)) / dt;
    vz(cc+1) = (z(cc+1) - z(cc)) / dt;

    cc = cc + 1;

    if cc > 1
        t = 0:dt:dt*(cc-1);
    end
end

% Crear una figura y establecer la configuración de subplot
subplot(3, 3, 5)
plot(t(1:cc),z(1:cc))
xlabel('Tiempo')
ylabel('Altura')

subplot(3, 3, 6)
plot(t(1:cc),E(1:cc))
xlabel('Tiempo')
ylabel('FEM')

subplot(3, 3, 7)
plot(t(1:cc),phi(1:cc))
xlabel('Tiempo')
ylabel('Phi')

subplot(3, 3, 8)
mesh(x,y,Bz(:,:,cc))
colorbar

function [Bz, phi, x, y] = B_due_m(m, z, R, ds)
    uo = 4*pi*10e-7;

    x = -R:ds:R;
    y = -R:ds:R;
    Lx = length(x);
    Ly = length(y);
    phi = 0;
    
    % if  (sqrt(x(i)^2 + y(i)^2 + z.^2) <= R)
    for i=1:Lx
        for j=1:Ly
            r = sqrt(x(i)^2 + y(j)^2 + z^2);
            if sqrt(x(i)^2 + y(j)^2) <= R
                Bz(i,j) = (uo / 4*pi) * (3*(z^2)*m - m*(r^2)) / r^5;
                phi = phi + Bz(i,j) * ds^2;
            end
        end
    end
end

