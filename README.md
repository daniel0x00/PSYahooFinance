# PSYahooFinance

Retrieves Stock Market quotes from Yahoo Finance API. 

Compatible with Windows PowerShell 5.1 and PowerShell 7.

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
        