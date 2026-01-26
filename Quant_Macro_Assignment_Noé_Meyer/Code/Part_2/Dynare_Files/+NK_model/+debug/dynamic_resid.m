function [lhs, rhs] = dynamic_resid(y, x, params, steady_state)
T = NaN(0, 1);
lhs = NaN(5, 1);
rhs = NaN(5, 1);
lhs(1) = y(6);
rhs(1) = params(1)*y(11)+params(2)*y(7);
lhs(2) = y(7);
rhs(2) = y(12)-1/params(3)*(y(8)-y(11)-y(9));
lhs(3) = y(8);
rhs(3) = y(6)*params(4)+y(7)*params(5)+y(10);
lhs(4) = y(9);
rhs(4) = params(6)*y(4)+x(1);
lhs(5) = y(10);
rhs(5) = params(7)*y(5)+x(2);
end
