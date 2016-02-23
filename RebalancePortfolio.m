function [Portfolio] = RebalancePortfolio(NewPortfolio, OldPortfolio)

N_old = OldPortfolio.Assets ;
N_new = NewPortfolio.Assets ;

oldTickers = cell(N_old,1);
for i = 1:N_old;
oldTickers(i) = OldPortfolio.Asset(i).Ticker;
end

newTickers = cell(N_new,1);
for i = 1:N_new;
newTickers(i) = NewPortfolio.Asset(i).Ticker;
end

%% find out changes in assets
[AssetInNewPortfolio,~] = ismember(oldTickers,newTickers);
RemovedAssetIndex = find(~AssetInNewPortfolio==1);
% RemovedAssets = oldTickers(~AssetInNewPortfolio);
HoldAssets = oldTickers(AssetInNewPortfolio);
[NewAddedAssets,~] = ismember(newTickers,HoldAssets);
NewAssetIndex = find(~NewAddedAssets==1);
% NewAssets = newTickers(~NewAddedAssets);

%% Sell Assets, Compute Revenue less commission, Add to Cash, Remove Positions
TotalRevenue = 0;
if length(RemovedAssetIndex)>0;
    for i = 1:length(RemovedAssetIndex);
    Revenue = OldPortfolio.Asset(RemovedAssetIndex(i)).Value - OldPortfolio.Asset(RemovedAssetIndex(i)).Commission;
    TotalRevenue = TotalRevenue + Revenue;
    
    Name = OldPortfolio.Asset(RemovedAssetIndex(i)).Ticker;
    Shares = OldPortfolio.Asset(RemovedAssetIndex(i)).Shares;
    PurchasePrice = OldPortfolio.Asset(RemovedAssetIndex(i)).PurchasePrice;
    CostofPosition = OldPortfolio.Asset(RemovedAssetIndex(i)).CostofPosition;
    CurrentPrice = OldPortfolio.Asset(RemovedAssetIndex(i)).CurrentPrice;
    Value = Revenue;
    Return = (Revenue-CostofPosition)/ CostofPosition;
    NewEntry = {NewPortfolio.Date, 'Sell', Name{1}, Shares, PurchasePrice, CostofPosition, Value, CurrentPrice, Return};
    OldPortfolio.TransactionHistory = [OldPortfolio.TransactionHistory;NewEntry];
    
    end
    OldPortfolio.Asset(RemovedAssetIndex)=[];
    OldPortfolio.Value = OldPortfolio.Value - TotalRevenue;
    OldPortfolio.Cash = OldPortfolio.Cash + TotalRevenue;
    OldPortfolio.TotalValue = OldPortfolio.Value + OldPortfolio.Cash;
    OldPortfolio.Assets = OldPortfolio.Assets-length(RemovedAssetIndex);
end
%% Buy Assets, Compute Cost less commission, Remove from Cash, Add Positions

TotalCost = 0;
TotalValue = 0;
if length(NewAssetIndex)>0
    for i = 1:length(NewAssetIndex);
        OldPortfolio.Asset = [OldPortfolio.Asset, NewPortfolio.Asset(NewAssetIndex(i))];
        Cost = NewPortfolio.Asset(NewAssetIndex(i)).CostofPosition;
        Value = NewPortfolio.Asset(NewAssetIndex(i)).Value;
        TotalCost = TotalCost + Cost;
        TotalValue = TotalValue + Value;
        
        Name = NewPortfolio.Asset(NewAssetIndex(i)).Ticker;
        Shares = NewPortfolio.Asset(NewAssetIndex(i)).Shares;
        PurchasePrice = NewPortfolio.Asset(NewAssetIndex(i)).PurchasePrice;
        CurrentPrice = NewPortfolio.Asset(NewAssetIndex(i)).CurrentPrice;
        Return = (Value-Cost)/Cost;
        NewEntry = {NewPortfolio.Date, 'Buy', Name{1}, Shares, PurchasePrice, Cost, Value,  CurrentPrice, Return};
        OldPortfolio.TransactionHistory = [OldPortfolio.TransactionHistory;NewEntry];
  
    end
    OldPortfolio.Cash = OldPortfolio.Cash - TotalCost;
    OldPortfolio.Value = OldPortfolio.Value + TotalValue;
    OldPortfolio.TotalValue = OldPortfolio.Cash+OldPortfolio.Value;
    OldPortfolio.Assets = OldPortfolio.Assets + length(NewAssetIndex);
end

%% Rebalance Portfolio, get current weights, buy & sell so that weights are not larger than Upper Bound
% 
% N_now = OldPortfolio.Assets;
% 
% for i = 1:N_now
%     AssetWeight = OldPortfolio.Asset(i).PositionValue/OldPortfolio.Value
%     if AssetWeight>UB
%         floor(

%% Portfolio

Portfolio = OldPortfolio;
end
