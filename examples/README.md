# PrinterOne Client Examples

This directory contains sample code demonstrating how to send data to PrinterOne server from various programming languages.

## Available Examples

### 📘 Python Examples (`python_examples.py`)

Comprehensive Python examples showing how to send data to PrinterOne using the built-in `socket` module.

**Examples included:**
1. **Simple Text** - Send a basic text message
2. **Multi-line Text** - Send formatted multi-line text
3. **Persian/Unicode Text** - Send Persian text with proper UTF-8 encoding
4. **File Contents** - Read and send file contents
5. **Error Handling** - Robust error handling and timeout management
6. **Reusable Class** - Object-oriented PrinterClient class for reuse

**Requirements:**
- Python 3.6+
- No additional libraries needed (uses built-in socket module)

**Usage:**
```bash
# Update PRINTER_HOST and PRINTER_PORT in the file, then run:
python python_examples.py

# Or import and use the PrinterClient class:
from python_examples import PrinterClient

printer = PrinterClient(host='192.168.1.100', port=9100)
printer.print_text("Hello World!")
```

---

### 📗 PowerShell Examples (`powershell_examples.ps1`)

Comprehensive PowerShell examples for Windows users.

**Examples included:**
1. **Simple Text** - Send a basic text message
2. **Multi-line Text** - Send formatted multi-line text with system info
3. **Persian/Unicode Text** - Send Persian text with proper encoding
4. **File Contents** - Read and send file contents
5. **Error Handling** - Comprehensive error handling
6. **Reusable Function** - `Send-ToPrinter` cmdlet for reuse
7. **Pipeline Integration** - Send PowerShell pipeline output to printer

**Requirements:**
- PowerShell 5.1+ or PowerShell Core 7+

**Usage:**
```powershell
# Update $PrinterHost and $PrinterPort in the file, then run:
powershell -ExecutionPolicy Bypass -File powershell_examples.ps1

# Or import and use the Send-ToPrinter function:
. .\powershell_examples.ps1
Send-ToPrinter -Text "Hello World!"
Send-ToPrinter -FilePath "document.txt"
```

---

## Quick Start Guide

### 1. Start PrinterOne Server

First, make sure the PrinterOne server is running:
```bash
# On Windows
PrinterOne.exe gui

# Or using Python
python server.py
```

### 2. Find Your Server IP

The server will display its IP address when it starts. You can also find it using:

**Windows:**
```powershell
ipconfig | findstr IPv4
```

**Linux/Mac:**
```bash
ip addr show | grep inet
# or
ifconfig | grep inet
```

### 3. Update Examples

Edit the example files and set the correct server address:
```python
# Python
PRINTER_HOST = '192.168.1.100'  # Your server IP
```

```powershell
# PowerShell
$PrinterHost = '192.168.1.100'  # Your server IP
```

### 4. Run Examples

Choose your preferred language and run the examples!

---

## Common Use Cases

### Send Simple Text

**Python:**
```python
import socket

def send_to_printer(text, host='localhost', port=9100):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((host, port))
        s.send(text.encode('utf-8'))

send_to_printer("Hello World!")
```

**PowerShell:**
```powershell
function Send-ToPrinter($Text, $Host='localhost', $Port=9100) {
    $client = New-Object System.Net.Sockets.TcpClient
    $client.Connect($Host, $Port)
    $stream = $client.GetStream()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Close()
    $client.Close()
}

Send-ToPrinter "Hello World!"
```

**Command Line (netcat):**
```bash
echo "Hello World" | nc localhost 9100
```

### Send Persian Text

**Python:**
```python
persian_text = "سلام دنیا!"
send_to_printer(persian_text)
```

**PowerShell:**
```powershell
Send-ToPrinter -Text "سلام دنیا!"
```

### Send File Contents

**Python:**
```python
with open('document.txt', 'rb') as f:
    data = f.read()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(('localhost', 9100))
    s.send(data)
```

**PowerShell:**
```powershell
$bytes = [System.IO.File]::ReadAllBytes("document.txt")
Send-ToPrinter -FilePath "document.txt"
```

---

## How PrinterOne Handles Data

### Plain Text
When you send plain text (like `"Hello World"`), PrinterOne automatically:
1. Detects it as plain text (not formatted printer data)
2. Converts it to PDF with proper formatting
3. Uses Unicode fonts (Tahoma/Arial) for international characters
4. Sends the PDF to the configured printer

### Formatted Printer Data
If you send formatted printer data (PCL, PostScript, ESC/P, ZPL, etc.), PrinterOne:
1. Detects the format
2. Passes it through unchanged to the printer
3. Lets the printer handle it directly

### Configuration
You can control this behavior in `config.json`:
```json
{
  "use_pdf_conversion": true,  // Enable automatic PDF conversion
  "printer_name": "Your Printer Name"
}
```

---

## Troubleshooting

### Connection Refused
**Problem:** Cannot connect to printer server

**Solutions:**
- Make sure PrinterOne server is running
- Check that the IP address and port are correct
- Verify firewall settings allow port 9100
- Try connecting from the same machine first (use `localhost`)

### Text Appears as Gibberish
**Problem:** Printed text shows random characters

**Solutions:**
- Make sure `use_pdf_conversion` is enabled in config.json
- Verify you're sending UTF-8 encoded text
- Check that the PrinterOne server is running the latest version with text-to-PDF conversion

### Persian/Unicode Text Not Working
**Problem:** Persian characters don't display correctly

**Solutions:**
- Ensure text is UTF-8 encoded when sending
- Make sure `use_pdf_conversion` is enabled
- Verify the server has Unicode fonts installed (Tahoma, Arial, or Times New Roman)

### Timeout Errors
**Problem:** Connection times out

**Solutions:**
- Check network connectivity between client and server
- Increase timeout value in your code
- Verify the server is not overloaded

---

## Additional Languages

Want to add examples in other languages? Here are the basic steps:

1. Create a TCP socket connection to `host:9100`
2. Send your data as UTF-8 encoded bytes
3. Close the connection

**Example in other languages:**

**JavaScript (Node.js):**
```javascript
const net = require('net');

function sendToPrinter(text, host='localhost', port=9100) {
    const client = new net.Socket();
    client.connect(port, host, () => {
        client.write(text);
        client.end();
    });
}

sendToPrinter("Hello World!");
```

**C#:**
```csharp
using System.Net.Sockets;
using System.Text;

void SendToPrinter(string text, string host = "localhost", int port = 9100)
{
    using (var client = new TcpClient(host, port))
    using (var stream = client.GetStream())
    {
        byte[] data = Encoding.UTF8.GetBytes(text);
        stream.Write(data, 0, data.Length);
    }
}

SendToPrinter("Hello World!");
```

**Bash/netcat:**
```bash
echo "Hello World" | nc localhost 9100
```

---

## Contributing

Have examples in other languages? Please contribute by:
1. Creating a new example file
2. Following the same structure (configuration, multiple examples, error handling)
3. Adding documentation in this README
4. Submitting a pull request

---

## License

These examples are part of the PrinterOne project and follow the same license.

---

## Support

For issues or questions:
- 📝 Open an issue on GitHub
- 📧 Contact: xtieume@gmail.com
- 📖 Read the main README.md for more information

---

**Happy Printing! 🖨️**
