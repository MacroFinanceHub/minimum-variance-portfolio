function [Portfolio] = UpdatePortfolio(Portfolio,Prices,Tickers,Date)

N = Portfolio.Assets ;
Asset_in_Portfolio = cell(N,1);
for i = 1:N;
Asset_in_Portfolio(i) = Portfolio.Asset(i).Ticker;
end

[~,Asset_Index] = ismember(Asset_in_Portfolio,Tickers);
Current_Prices = Prices(Asset_Index);

Value=0;
for i = 1:N
    Portfolio.Asset(i).CurrentPrice = Current_Prices(i);
    Portfolio.Asset(i).Value = Current_Prices(i)*Portfolio.Asset(i).Shares;
    Portfolio.Asset(i).Return = (Portfolio.Asset(i).Value-Portfolio.Asset(i).CostofPosition)/Portfolio.Asset(i).CostofPosition;
    Value = Value + Portfolio.Asset(i).Value;
end
Portfolio.Value = Value;
Portfolio.TotalValue = Value + Portfolio.Cash;
Portfolio.Date = datestr(Date);

for i = 1:N;
    Portfolio.View(i+1,6) = {Portfolio.Asset(i).CurrentPrice};
    Portfolio.View(i+1,7) = {Portfolio.Asset(i).Value};
    Portfolio.View(i+1,8) = {Portfolio.Asset(i).Return};
end

% disp(' ')
% disp(Portfolio.View)
end

