import scipy.io
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import datetime as dt

mat = scipy.io.loadmat('daily_adjusted_close.mat', squeeze_me = True)
returns = mat["returns"]
prices = mat["prices"]
dates = [dt.datetime.fromordinal(date) for date in mat["dates"]]
tickers = mat["cleanTickers"].tolist()
prices_df = pd.DataFrame(prices, index=dates, columns=tickers)
returns_df = pd.DataFrame(returns, index=dates, columns=tickers)

returns_df.cumsum().plot()
plt.show()
