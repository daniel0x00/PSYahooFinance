# PSYahooFinance

Retrieves OHLC (Open, High, Low, Close) Stock Market quotes from Yahoo Finance API, **live data** and **historical data**. 

Compatible with `Windows PowerShell 5.1` and `PowerShell 7`.

## Install

### PowerShell Gallery (preferred)
```powershell
Install-Module PSYahooFinance -Force
Import-Module PSYahooFinance
```

### Invokation
```powershell
iex((iwr https://raw.githubusercontent.com/daniel0x00/PSYahooFinance/main/Get-YFStockQuote.ps1 -UseBasicParsing).content)
```

## Usage

### Bitcoin-USD, 1d candles, -1year lookback.
```powershell
PS C:\> Get-YFStockQuote -Symbol BTC-USD -Range 1y
```
```console
timestamp : 1589756400
symbol    : BTC-USD
interval  : 1d
open      : 9675.7
high      : 9906.03
low       : 9570.36
close     : 9726.58
volume    : 41827139895

timestamp : 1589842800
symbol    : BTC-USD
interval  : 1d
open      : 9727.06
high      : 9836.05
low       : 9539.62
close     : 9729.04
volume    : 39254288954
```

### S&P-500 ETF, 5m candles, -1month lookback.
```powershell
PS C:\> Get-YFStockQuote -Symbol SPY -Interval 5m -Range 1mo
```
```console
timestamp : 1606855800
symbol    : SPY
interval  : 5m
open      : 366.04
high      : 366.44
low       : 365.57
close     : 366.39
volume    : 3285779

timestamp : 1606856100
symbol    : SPY
interval  : 5m
open      : 366.39
high      : 366.4
low       : 365.76
close     : 365.98
volume    : 3926745
```

### Apple stock, 2m candles, -10days from today lookback.
```powershell
PS C:\> Get-YFStockQuote -Symbol AAPL -Interval 2m -FromDate -10
```
```console
timestamp : 1606746600
symbol    : AAPL
interval  : 2m
open      : 117.34
high      : 117.7
low       : 117.28
close     : 117.59
volume    : 4445463

timestamp : 1606746720
symbol    : AAPL
interval  : 2m
open      : 117.63
high      : 118.3
low       : 117.56
close     : 118.09
volume    : 1850952
```

### Live data, Apple stock, 1m candles.
```powershell
PS C:\> Get-YFStockQuote -Symbol AAPL -Interval 1m -Range 1d | ft
```
```console
timestamp symbol interval   open   high    low  close  volume
 --------- ------ --------   ----   ----    ---  -----  ------
1609770600 AAPL   1m       133.37 133.61 132.95 133.15 4263981
1609770660 AAPL   1m       133.13 133.45 133.08 133.34  534461
1609770720 AAPL   1m       133.35 133.36 132.99 133.11  526067
1609770780 AAPL   1m       133.11 133.15 132.71 132.75  555639
1609770840 AAPL   1m       132.73 132.83 132.39 132.81  744817
1609770900 AAPL   1m            0      0      0      0       0
1609770917 AAPL   1m       132.75 132.75 132.75 132.75       0
```

Note that the last 2 objects. `1609770900` represents the current minute value when the candle is closed -which hasn't happened yet, thereby `0` values-, whereas the `1609770917` value is the current timestamp, meaning 'non-closed candle' (temporal results).
        
