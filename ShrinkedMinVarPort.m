function [PortWts, PortRisk, PortReturns] = ShrinkedMinVarPort(Returns,UB)

%% Estimate sample moments
[T,N] = size(Returns);
S = cov(Returns,1);
m = mean(Returns,1);
iota = ones(N,1);

%%  James-Stein Shrinkage Estimator
m_0 = mean(m);          %Grand mean across all assets
delta = min([1 ; (m-m_0*iota')*(S\(m-m_0*iota')')\((N-2)/T)]); 
m_JS = delta*m_0+(1-delta)*m;

if UB>1;
    UB = 1;
end

%% portfolio Optimizer
Aeq = [m ;iota']; %Weights must sum to one and have target return
lb = zeros(N,1);  %Individual weights must be equal or larger than 0
ub = UB*ones(N,1);   %Individual weights must be equal or smaller than 1

PortReturns = mean(m_JS);
beq = [PortReturns ; 1];
[PortWts, PortRisk] = qplcprog(2*S, [], [], [], Aeq, beq, lb, ub);
PortRisk = sqrt(PortRisk);
end