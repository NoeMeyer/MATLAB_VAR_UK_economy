
// Preamble
//***********************************************************

// Declare variables and parameters

var pi y i rn u;
varexo e_r e_u;
parameters beta kappa sigma phi_pi phi_y rho_r rho_u sigma_r sigma_u;


// Parameterisation
	
beta=0.99;
kappa=0.1275;
sigma=1;
phi_pi= 6;
phi_y=0.125;
rho_r=0.9;
rho_u=0.5;
sigma_r=0.01; 
sigma_u=0.0025;


// Model
//***********************************************************

model(linear);

pi = beta*pi(+1)+kappa*y;  // Phillips curve

y = y(+1)-1/sigma*(i-pi(+1)-rn);  // IS curve

i = phi_pi*pi+phi_y*y+u;  // Taylor rule

rn = rho_r*rn(-1)+e_r;

u = rho_u*u(-1)+e_u; 

end;


// Steady State
//***********************************************************

initval;

pi=0;

y=0;

i=0;

rn=0;

u=0;

end;

steady;
resid;


// Specification of Shocks
//***********************************************************

shocks;

var e_r = sigma_r^2;

var e_u = sigma_u^2;

end;


// Computation
//***********************************************************

stoch_simul(irf=20);


