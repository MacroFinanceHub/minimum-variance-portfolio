%% ------------------ BACKTEST MINIMUM VARIANCE -------------------------%%

% Get Data
load daily_adjusted_close.mat

% set upper bound on portfolio weights
UB = 0.025;
Wealth = 100000000;
Years = 9;
TestLength = 252*Years;
RebalancingFrequency = 63;  %quarterly rebalancing
window = TestLength:-RebalancingFrequency:0;

% initial portfolio
Returns = returns(1:end-window(1),:);
Prices = prices(end-window(1),:);
Date = dates(end-window(1),:);
[PortWts, ~, ~] = ShrinkedMinVarPort(Returns,UB);
Portfolio_0 = ConstructPortfolio(PortWts,cleanTickers,Prices,Wealth,Date);  
PortValue = zeros(length(window)-1,4);
PortValue(1,1)=dates(end-window(1),:);
PortValue(1,2)=Portfolio_0.Value;
PortValue(1,3)=Portfolio_0.Cash;
PortValue(1,4)=Portfolio_0.Cash+Portfolio_0.Value;
for i = 2:length(window)
    %update data
    Returns = returns(1:end-window(i),:);
    Prices = prices(end-window(i),:);
    Date = dates(end-window(i),:);
    % update portfolio
    [Portfolio_0] = UpdatePortfolio(Portfolio_0,Prices,cleanTickers,Date);
    
    % estimate new portfolio
    [PortWts, ~, ~] = ShrinkedMinVarPort(Returns,UB);
    Portfolio_1 = ConstructPortfolio(PortWts,cleanTickers,Prices,Wealth,Date);
    
    % rebalance portfolio
    [Portfolio_0] = RebalancePortfolio(Portfolio_1, Portfolio_0);
    
    %track performance after rebalancing
    PortValue(i,4)=Portfolio_0.Cash+Portfolio_0.Value;
    PortValue(i,3) = Portfolio_0.Value;
    PortValue(i,2) = Portfolio_0.Cash;
    PortValue(i,1) = Date;
    Wealth  = PortValue(i,4);
    disp(i)
end
plot(PortValue(:,1), [PortValue(:,3) PortValue(:,4)])
legend('Total Equity Holdings', 'Total Portfolio Value')
datetick('x','QQ-YYYY' ,'keeplimits', 'keepticks')
title('Shrinked Minimum Variance Portfolio Value')
xlabel('Date')
ylabel('Portfolio Value')
axis([PortValue(1,1),PortValue(end,1),min(PortValue(:,4)),max(PortValue(:,4))])

%portfolio evaluation
PortReturns = (PortValue(2:end,4)-PortValue(1:end-1,4))./PortValue(1:end-1,4);
mu = mean(PortReturns)*(252/RebalancingFrequency);
sig = std(PortReturns)*sqrt(252/RebalancingFrequency);
mu/sig


%generate excel stuff
[rows, ~] = size(Portfolio_0.TransactionHistory);
destination = strcat('A1',':I',num2str(rows));
xlswrite('test.xls',Portfolio_0.TransactionHistory,destination);
xlswrite('test.xls',[cleanTickers ,num2cell(Prices')] ,'LatestPricesSheet');
xlswrite('minvarport.xls',Portfolio_1.View);
winopen('test.xls')
winopen('minvarport.xls')

