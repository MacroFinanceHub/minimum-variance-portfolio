function [Portfolio] = ConstructPortfolio(PortWts,Tickers,Prices,Wealth,Date)
%% Find Asset Indices & respective Tickers
AssetIndex = PortWts>0;
PortWts(PortWts==0)=[];
PortTickers = Tickers(AssetIndex);
TotalAssets = length(PortTickers);
%% Compute Portfolio Values
PurchasePrice=Prices(AssetIndex);
NoShares = floor(Wealth*PortWts./PurchasePrice');
Commission = ceil(NoShares/100);
CostofPosition = NoShares.*PurchasePrice'+Commission;
PositionValue = NoShares.*PurchasePrice';
Cash = Wealth - sum(CostofPosition);
Portfolio.TransactionHistory ={};
TransactionHeader = {'Date', 'Action', 'Ticker', 'Shares', 'PurchasePrice', 'CostofPosition', 'Value', 'Current Price', 'Return'};
Portfolio.TransactionHistory=[Portfolio.TransactionHistory;TransactionHeader];
for i = 1:TotalAssets
    Portfolio.Asset(i).Ticker = PortTickers(i);
    Portfolio.Asset(i).Shares = NoShares(i);
    Portfolio.Asset(i).PurchasePrice = PurchasePrice(i);
    Portfolio.Asset(i).Commission = Commission(i);
    Portfolio.Asset(i).CostofPosition = CostofPosition(i);
    Portfolio.Asset(i).Value = PositionValue(i);
    Portfolio.Asset(i).CurrentPrice = PurchasePrice(i);
    Return = (PositionValue(i) - CostofPosition(i))/(CostofPosition(i));
    Portfolio.Asset(i).Return = Return;
    Portfolio.Cash = Cash;
    Portfolio.Value = sum(PositionValue);
    Portfolio.TotalValue = Cash + sum(PositionValue);
    Portfolio.Date = datestr(Date);
    Portfolio.Assets = TotalAssets;
    NewEntry = {Portfolio.Date, 'Buy', PortTickers{i}, NoShares(i),PurchasePrice(i), CostofPosition(i), PositionValue(i), PurchasePrice(i), Return};
    Portfolio.TransactionHistory=[Portfolio.TransactionHistory;NewEntry];
end

Portfolio_Dashboard=cell(TotalAssets,8);
Portfolio_header = {'Symbol', 'Shares', 'Purchase Price', 'Commission', 'Wealth Invested', 'Current Price', 'Position Value', 'Return'};
for i = 1:TotalAssets;
    Portfolio_Dashboard(i,:) = {PortTickers{i}, NoShares(i), PurchasePrice(i), Commission(i), CostofPosition(i), Portfolio.Asset(i).CurrentPrice,PositionValue(i), Portfolio.Asset(i).Return};
end
Portfolio.View = [ Portfolio_header ; Portfolio_Dashboard];
% disp(' ')
% disp(Portfolio.View)
end
