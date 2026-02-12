# PrinterOne - PowerShell Client Examples
#
# This file demonstrates how to send data to a PrinterOne server using PowerShell.
# The PrinterOne server listens on port 9100 (standard RAW printing port).
#
# Requirements:
#     - PowerShell 5.1+ or PowerShell Core 7+
#     - PrinterOne server running on the network
#
# Usage:
#     powershell -ExecutionPolicy Bypass -File powershell_examples.ps1
#     OR
#     pwsh powershell_examples.ps1  (PowerShell Core)


# =============================================================================
# Configuration
# =============================================================================

$PrinterHost = 'localhost'  # Change to your PrinterOne server IP
$PrinterPort = 9100         # Default RAW printing port


# =============================================================================
# Example 1: Send Simple Text
# =============================================================================

function Example-1-SimpleText {
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Example 1: Send Simple Text"
    Write-Host ("=" * 60)
    
    $text = "Hello from PrinterOne!`nThis is a test print job.`n"
    
    try {
        # Create TCP client
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($PrinterHost, $PrinterPort)
        
        # Get network stream
        $stream = $client.GetStream()
        
        # Convert text to bytes (UTF-8 encoding)
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        
        # Send data
        $stream.Write($bytes, 0, $bytes.Length)
        
        Write-Host "✓ Successfully sent $($bytes.Length) bytes to printer" -ForegroundColor Green
        Write-Host "  Text: $($text.Trim())"
        
        # Clean up
        $stream.Close()
        $client.Close()
        
    }
    catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
        Write-Host "  Make sure PrinterOne server is running on ${PrinterHost}:${PrinterPort}" -ForegroundColor Yellow
    }
}


# =============================================================================
# Example 2: Send Multi-line Text
# =============================================================================

function Example-2-MultilineText {
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Example 2: Send Multi-line Text"
    Write-Host ("=" * 60)
    
    # Multi-line text with formatting
    $text = @"
╔═══════════════════════════════════════╗
║      PrinterOne Test Print Job        ║
╚═══════════════════════════════════════╝

Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Job ID: PS-TEST-001
Computer: $env:COMPUTERNAME

Content:
--------
This is a multi-line test print job
demonstrating PrinterOne capabilities.

Line 1: Testing line breaks
Line 2: Testing special characters !@#$%
Line 3: Testing numbers 1234567890

End of test print job.
"@
    
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($PrinterHost, $PrinterPort)
        $stream = $client.GetStream()
        
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        $stream.Write($bytes, 0, $bytes.Length)
        
        Write-Host "✓ Successfully sent multi-line text ($($bytes.Length) bytes)" -ForegroundColor Green
        
        $stream.Close()
        $client.Close()
    }
    catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
}


# =============================================================================
# Example 3: Send Persian/Unicode Text
# =============================================================================

function Example-3-PersianText {
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Example 3: Send Persian/Unicode Text"
    Write-Host ("=" * 60)
    
    # Persian text (Hello World in Persian)
    # Note: Save this file as UTF-8 with BOM for proper Persian display
    $persianText = @"
سلام دنیا!

این یک تست چاپ متن فارسی است.

PrinterOne از متن فارسی پشتیبانی می‌کند.

خط ۱: آزمایش اعداد فارسی ۱۲۳۴۵۶۷۸۹۰
خط ۲: آزمایش کاراکترهای خاص !@#$%

پایان تست.
"@
    
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($PrinterHost, $PrinterPort)
        $stream = $client.GetStream()
        
        # Persian text must be UTF-8 encoded
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($persianText)
        $stream.Write($bytes, 0, $bytes.Length)
        
        Write-Host "✓ Successfully sent Persian text ($($bytes.Length) bytes)" -ForegroundColor Green
        Write-Host "  Note: Text will be converted to PDF with Unicode fonts" -ForegroundColor Cyan
        
        $stream.Close()
        $client.Close()
    }
    catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
}


# =============================================================================
# Example 4: Send File Contents
# =============================================================================

function Example-4-SendFile {
    param(
        [string]$FilePath = $null
    )
    
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Example 4: Send File Contents"
    Write-Host ("=" * 60)
    
    # Create a test file if none provided
    if (-not $FilePath) {
        $FilePath = "test_print.txt"
        $testContent = @"
This is a test file for PrinterOne.

File: test_print.txt
Created for demonstration purposes.

Content goes here...
Line 1
Line 2
Line 3

End of file.
"@
        $testContent | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "  Created test file: $FilePath"
    }
    
    try {
        # Check if file exists
        if (-not (Test-Path $FilePath)) {
            Write-Host "✗ Error: File '$FilePath' not found" -ForegroundColor Red
            return
        }
        
        # Read file contents as bytes
        $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
        
        # Send to printer
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($PrinterHost, $PrinterPort)
        $stream = $client.GetStream()
        $stream.Write($fileBytes, 0, $fileBytes.Length)
        
        Write-Host "✓ Successfully sent file '$FilePath' ($($fileBytes.Length) bytes)" -ForegroundColor Green
        
        $stream.Close()
        $client.Close()
        
        # Clean up test file
        if ($FilePath -eq "test_print.txt") {
            Remove-Item $FilePath -Force
            Write-Host "  Cleaned up test file"
        }
    }
    catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
}


# =============================================================================
# Example 5: Send Data with Error Handling
# =============================================================================

function Example-5-WithErrorHandling {
    param(
        [string]$Text,
        [int]$TimeoutSeconds = 5
    )
    
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Example 5: Send with Error Handling"
    Write-Host ("=" * 60)
    
    try {
        # Create TCP client with timeout
        $client = New-Object System.Net.Sockets.TcpClient
        $client.SendTimeout = $TimeoutSeconds * 1000
        $client.ReceiveTimeout = $TimeoutSeconds * 1000
        
        # Connect
        Write-Host "  Connecting to ${PrinterHost}:${PrinterPort}..."
        $client.Connect($PrinterHost, $PrinterPort)
        Write-Host "  ✓ Connected" -ForegroundColor Green
        
        # Get stream
        $stream = $client.GetStream()
        
        # Send data
        Write-Host "  Sending $($Text.Length) characters..."
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        $stream.Write($bytes, 0, $bytes.Length)
        Write-Host "  ✓ Data sent successfully" -ForegroundColor Green
        
        # Close
        $stream.Close()
        $client.Close()
        Write-Host "  ✓ Connection closed" -ForegroundColor Green
        
        return $true
    }
    catch [System.Net.Sockets.SocketException] {
        Write-Host "  ✗ Socket Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "     Make sure PrinterOne server is running on ${PrinterHost}:${PrinterPort}" -ForegroundColor Yellow
        return $false
    }
    catch {
        Write-Host "  ✗ Error: $($_.Exception.GetType().Name): $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}


# =============================================================================
# Example 6: Reusable Print Function
# =============================================================================

function Send-ToPrinter {
    <#
    .SYNOPSIS
        Send data to PrinterOne server.
    
    .DESCRIPTION
        A reusable function to send text or file data to a PrinterOne network printer.
    
    .PARAMETER Text
        Text string to send to printer
    
    .PARAMETER FilePath
        Path to file to send to printer
    
    .PARAMETER PrinterHost
        PrinterOne server hostname or IP address (default: localhost)
    
    .PARAMETER PrinterPort
        PrinterOne server port (default: 9100)
    
    .PARAMETER Encoding
        Text encoding to use (default: UTF8)
    
    .EXAMPLE
        Send-ToPrinter -Text "Hello World"
    
    .EXAMPLE
        Send-ToPrinter -FilePath "document.txt"
    
    .EXAMPLE
        Send-ToPrinter -Text "سلام دنیا" -PrinterHost "192.168.1.100"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, ParameterSetName="Text")]
        [string]$Text,
        
        [Parameter(Mandatory=$false, ParameterSetName="File")]
        [string]$FilePath,
        
        [string]$PrinterHost = 'localhost',
        [int]$PrinterPort = 9100,
        
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8
    )
    
    try {
        # Determine what to send
        if ($PSCmdlet.ParameterSetName -eq "Text") {
            if ([string]::IsNullOrEmpty($Text)) {
                throw "Text cannot be empty"
            }
            $bytes = $Encoding.GetBytes($Text)
        }
        else {
            if (-not (Test-Path $FilePath)) {
                throw "File '$FilePath' not found"
            }
            $bytes = [System.IO.File]::ReadAllBytes($FilePath)
        }
        
        # Connect and send
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($PrinterHost, $PrinterPort)
        $stream = $client.GetStream()
        $stream.Write($bytes, 0, $bytes.Length)
        
        # Clean up
        $stream.Close()
        $client.Close()
        
        Write-Verbose "Successfully sent $($bytes.Length) bytes to ${PrinterHost}:${PrinterPort}"
        return $true
    }
    catch {
        Write-Error "Failed to send to printer: $_"
        return $false
    }
}


function Example-6-ReusableFunction {
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Example 6: Using Reusable Send-ToPrinter Function"
    Write-Host ("=" * 60)
    
    # Example 1: Print simple text
    Write-Host "`n  Testing simple text..."
    if (Send-ToPrinter -Text "Hello from Send-ToPrinter function!" -Verbose) {
        Write-Host "  ✓ Printed simple text" -ForegroundColor Green
    }
    
    # Example 2: Print Persian text
    Write-Host "`n  Testing Persian text..."
    if (Send-ToPrinter -Text "سلام از تابع Send-ToPrinter!" -Verbose) {
        Write-Host "  ✓ Printed Persian text" -ForegroundColor Green
    }
}


# =============================================================================
# Example 7: Advanced - Send with Pipeline
# =============================================================================

function Example-7-Pipeline {
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Example 7: Send Data via Pipeline"
    Write-Host ("=" * 60)
    
    # Example: Get process list and send to printer
    $processInfo = Get-Process | Select-Object -First 10 Name, CPU, WorkingSet | 
        Format-Table -AutoSize | Out-String
    
    $report = @"
Process Report
Generated: $(Get-Date)
Computer: $env:COMPUTERNAME

$processInfo

End of Report
"@
    
    try {
        if (Send-ToPrinter -Text $report -Verbose) {
            Write-Host "✓ Sent process report to printer" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "✗ Error sending report: $_" -ForegroundColor Red
    }
}


# =============================================================================
# Main Script
# =============================================================================

function Main {
    Write-Host ""
    Write-Host ("╔" + ("=" * 58) + "╗")
    Write-Host ("║" + (" " * 8) + "PrinterOne - PowerShell Client Examples" + (" " * 10) + "║")
    Write-Host ("╚" + ("=" * 58) + "╝")
    Write-Host ""
    Write-Host "Server: ${PrinterHost}:${PrinterPort}"
    Write-Host "Note: Make sure PrinterOne server is running!"
    
    # Run examples
    Example-1-SimpleText
    Example-2-MultilineText
    Example-3-PersianText
    Example-4-SendFile
    Example-5-WithErrorHandling -Text "Test with error handling"
    Example-6-ReusableFunction
    Example-7-Pipeline
    
    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "All examples completed!"
    Write-Host ("=" * 60)
    Write-Host ""
}

# Run main function
Main
