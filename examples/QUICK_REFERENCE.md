# PrinterOne - Quick Reference Card

Quick copy-paste examples for sending data to PrinterOne.

## Configuration
- **Default Port**: 9100
- **Protocol**: TCP/IP
- **Encoding**: UTF-8

---

## Python

### Minimal Example
```python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('localhost', 9100))
s.send(b'Hello World')
s.close()
```

### With UTF-8 Encoding
```python
import socket

text = "Hello World! سلام دنیا!"
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(('localhost', 9100))
    s.send(text.encode('utf-8'))
```

### Send File
```python
import socket

with open('document.txt', 'rb') as f:
    data = f.read()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(('localhost', 9100))
    s.send(data)
```

### Reusable Function
```python
import socket

def print_to_network(text, host='localhost', port=9100):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((host, port))
            s.send(text.encode('utf-8'))
        return True
    except Exception as e:
        print(f"Error: {e}")
        return False

# Usage
print_to_network("Hello World!")
```

---

## PowerShell

### Minimal Example
```powershell
$client = New-Object System.Net.Sockets.TcpClient
$client.Connect('localhost', 9100)
$stream = $client.GetStream()
$bytes = [System.Text.Encoding]::UTF8.GetBytes('Hello World')
$stream.Write($bytes, 0, $bytes.Length)
$stream.Close()
$client.Close()
```

### Send Text Function
```powershell
function Send-ToPrinter {
    param([string]$Text, [string]$Host = 'localhost', [int]$Port = 9100)
    
    $client = New-Object System.Net.Sockets.TcpClient
    $client.Connect($Host, $Port)
    $stream = $client.GetStream()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Close()
    $client.Close()
}

# Usage
Send-ToPrinter -Text "Hello World!"
```

### Send File
```powershell
$bytes = [System.IO.File]::ReadAllBytes('document.txt')
$client = New-Object System.Net.Sockets.TcpClient
$client.Connect('localhost', 9100)
$stream = $client.GetStream()
$stream.Write($bytes, 0, $bytes.Length)
$stream.Close()
$client.Close()
```

### One-Liner
```powershell
"Hello World" | % { $c=[Net.Sockets.TcpClient]::new('localhost',9100); $s=$c.GetStream(); $b=[Text.Encoding]::UTF8.GetBytes($_); $s.Write($b,0,$b.Length); $s.Close(); $c.Close() }
```

---

## Bash/Linux

### Using netcat
```bash
echo "Hello World" | nc localhost 9100
```

### Send File
```bash
cat document.txt | nc localhost 9100
```

### Here-doc
```bash
nc localhost 9100 << EOF
Line 1
Line 2
Line 3
EOF
```

---

## C#

### Basic Example
```csharp
using System.Net.Sockets;
using System.Text;

void PrintToNetwork(string text, string host = "localhost", int port = 9100)
{
    using var client = new TcpClient(host, port);
    using var stream = client.GetStream();
    byte[] data = Encoding.UTF8.GetBytes(text);
    stream.Write(data, 0, data.Length);
}

PrintToNetwork("Hello World!");
```

---

## JavaScript (Node.js)

### Basic Example
```javascript
const net = require('net');

function printToNetwork(text, host = 'localhost', port = 9100) {
    const client = new net.Socket();
    client.connect(port, host, () => {
        client.write(text);
        client.end();
    });
}

printToNetwork("Hello World!");
```

### With Promise
```javascript
const net = require('net');

function printToNetwork(text, host = 'localhost', port = 9100) {
    return new Promise((resolve, reject) => {
        const client = new net.Socket();
        client.connect(port, host, () => {
            client.write(text);
            client.end();
            resolve();
        });
        client.on('error', reject);
    });
}

// Usage
printToNetwork("Hello World!")
    .then(() => console.log('Sent'))
    .catch(err => console.error('Error:', err));
```

---

## cURL

### Basic
```bash
curl telnet://localhost:9100 <<< "Hello World"
```

### Send File
```bash
curl -T document.txt telnet://localhost:9100
```

---

## Common Issues

### Connection Refused
- Make sure PrinterOne server is running
- Check firewall settings (port 9100 must be open)
- Verify correct IP address

### Text Appears Garbled
- Enable `use_pdf_conversion` in config.json
- Make sure text is UTF-8 encoded
- Update to latest version with text-to-PDF conversion

### Persian/Unicode Issues
- Use UTF-8 encoding when sending
- Enable `use_pdf_conversion` in server config
- Make sure Unicode fonts are installed (Tahoma, Arial)

---

## Network Diagnostics

### Test Connection
```bash
# Linux/Mac
nc -zv localhost 9100

# Windows (PowerShell)
Test-NetConnection -ComputerName localhost -Port 9100
```

### Find Server IP
```bash
# Linux
ip addr show | grep inet

# Windows
ipconfig | findstr IPv4
```

---

## For More Examples

See the [examples](examples/) directory for comprehensive examples including:
- Error handling
- Timeout management
- Reusable classes/functions
- File operations
- Persian/Unicode text support

**Files:**
- `examples/python_examples.py` - Detailed Python examples
- `examples/powershell_examples.ps1` - Detailed PowerShell examples
- `examples/README.md` - Full documentation
