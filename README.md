# minimum-variance-portfolio
contains minimum variance portfolio backtesting code in matlab

daily_adjusted_close contains sample date that can be used to run the backtest.

1. BackTestPortfolio contains the script for running the backtest, it calls to the following functions:
2.   ShrinkedMinVarPort is the optimizer called to assign weights to assets.
3.   UpdatePortfolio updates the asset values at each update step.
4.   ConstructPortfolio builds portfolios based on assigned asset weights
5.   RebalancePortfolio checks changes in portfolio composition and buys/sells removed/new assets.

