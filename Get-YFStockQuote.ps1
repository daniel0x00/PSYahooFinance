function Get-YFStockQuote {
    # Author: Daniel Ferreira (@daniel0x00)  
    # License: 0BSD

    <#

    .SYNOPSIS
        Downloads delayed Yahoo Finance Stock Market Quote data. Very basic and non-polished cmdlet.

    .EXAMPLE 
        # Bitcoin-USD, 1d candles, -1year lookback.
        Get-YFStockQuote -Symbol BTC-USD -Range 1y

    .EXAMPLE
        # S&P-500 ETF, 5m candles, -1month lookback.
        Get-YFStockQuote -Symbol SPY -Interval 5m -Range 1mo
    
    .EXAMPLE
        # Apple stock, 2m candles, -40days from today lookback.
        Get-YFStockQuote -Symbol AAPL -Interval 2m -FromDate -40

    .OUTPUTS
        timestamp : 1606833000
        symbol    : SPY
        interval  : 5m
        open      : 365.6
        high      : 365.62
        low       : 364.93
        close     : 365.11
        volume    : 3052904

        timestamp : 1606833300
        symbol    : SPY
        interval  : 5m
        open      : 365.06
        high      : 365.77
        low       : 364.93
        close     : 365.68
        volume    : 944011

    #>   
    [CmdletBinding(DefaultParameterSetName='ByRange')]
    [OutputType([PSCustomObject])]
    param(    
        [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$true)]
        [string] $Symbol='SPY',

        # Candle size. '30m' is banned as it returns 60m candles. Possible TODO to anybody else to fix.
        [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
        [ValidateSet("1m","2m","5m","15m","60m","90m","1h","1d","5d","1wk","1mo","3mo")]
        [string] $Interval='1d',

        # How far back it goes:
        [Parameter(Mandatory=$false, ValueFromPipeline=$false, ParameterSetName='ByRange')]
        [ValidateSet("1d","5d","1mo","3mo","6mo","1y","2y","5y","10y","ytd","max")]
        [string] $Range='5d',

        # How far back it goes, by date. Default is -30d:
        [Parameter(Mandatory=$false, ValueFromPipeline=$false, ParameterSetName='ByDate')]
        [int] $FromDate=([int](New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date).AddDays(-30).ToLocalTime()).TotalSeconds),

        # Till how far back it goes, by date. Default is -1d:
        [Parameter(Mandatory=$false, ValueFromPipeline=$false, ParameterSetName='ByDate')]
        [int] $ToDate=([int](New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date).AddDays(-1).ToLocalTime()).TotalSeconds),

        # Switch to skip candle size output.
        # By default is $false, thereby will be shown. 
        # 'Interval' field is useful when all intervals are ingested as single file in a data warehouse platform.
        [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
        [switch] $SkipIntervalOutput,

        # Yahoo Finance base URL:
        [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
        [string] $UrlBase='https://query1.finance.yahoo.com/v8/finance/chart/'
    )

    switch ($PsCmdlet.ParameterSetName) {
        "ByRange" { $Url = [string]::concat($UrlBase, ("{0}?region=US&lang=en-US&includePrePost=false&interval={1}&range={2}&corsDomain=finance.yahoo.com&.tsrc=finance" -f $Symbol,$Interval,$Range) ) }
        "ByDate" { 
            # Received relative days:
            if ($FromDate -lt 0) { $FromDate = ([int](New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date).AddDays($FromDate).ToLocalTime()).TotalSeconds) }
            if ($ToDate -lt 0) { $ToDate = ([int](New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date).AddDays($ToDate).ToLocalTime()).TotalSeconds) }

            $Url = [string]::concat($UrlBase, ("{0}?region=US&lang=en-US&includePrePost=false&interval={1}&period1={2}&period2={3}&corsDomain=finance.yahoo.com&.tsrc=finance" -f $Symbol,$Interval,$FromDate,$ToDate) )
        }
    }
    Write-Verbose "[Get-YFStockQuote] Downloading $Symbol quotes from URL: $Url..."

    # Request builder:
    $WebRequestParameters = @{
        Uri = $Url
        Method = 'Get'
        Headers = @{
            "Accept"="*/*"
            "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
        }
    }

    $WebRequest = Invoke-RestMethod @WebRequestParameters -ErrorAction Stop

    # Output: 
    if ($null -ne $WebRequest) { 
        $Output = 1..($WebRequest.chart.result[0].timestamp.count) | Select-Object `
            @{n='timestamp';e={ $WebRequest.chart.result[0].timestamp[($_-1)] }}, `
            @{n='symbol';e={ $Symbol }}, `
            @{n='interval';e={ $Interval }}, `
            @{n='open';e={ [System.Math]::Round($WebRequest.chart.result[0].indicators.quote[0].open[($_-1)],2) }}, `
            @{n='high';e={ [System.Math]::Round($WebRequest.chart.result[0].indicators.quote[0].high[($_-1)],2) }}, `
            @{n='low';e={ [System.Math]::Round($WebRequest.chart.result[0].indicators.quote[0].low[($_-1)],2) }}, `
            @{n='close';e={ [System.Math]::Round($WebRequest.chart.result[0].indicators.quote[0].close[($_-1)],2) }}, `
            #@{n='adjclose';e={ [System.Math]::Round($WebRequest.chart.result[0].indicators.adjclose[0].adjclose[($_-1)],2) }}, `
            @{n='volume';e={ [System.Math]::Round($WebRequest.chart.result[0].indicators.quote[0].volume[($_-1)],2) }}
        
        # Output:
        if ($SkipIntervalOutput) { $Output | Select-Object -ExcludeProperty interval }
        else { $Output }
    }
}