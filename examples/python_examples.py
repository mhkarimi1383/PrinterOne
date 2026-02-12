#!/usr/bin/env python3
"""
PrinterOne - Python Client Examples

This file demonstrates how to send data to a PrinterOne server using Python.
The PrinterOne server listens on port 9100 (standard RAW printing port).

Requirements:
    - Python 3.6+
    - PrinterOne server running on the network
    - No additional libraries required (uses built-in socket module)

Usage:
    python python_examples.py
"""

import socket
import sys
from pathlib import Path


# =============================================================================
# Configuration
# =============================================================================

# Server configuration - update these values for your setup
PRINTER_HOST = 'localhost'  # Change to your PrinterOne server IP
PRINTER_PORT = 9100         # Default RAW printing port


# =============================================================================
# Example 1: Send Simple Text
# =============================================================================

def example_1_simple_text():
    """Send a simple text message to the printer."""
    print("\n" + "="*60)
    print("Example 1: Send Simple Text")
    print("="*60)
    
    text = "Hello from PrinterOne!\nThis is a test print job.\n"
    
    try:
        # Create a TCP socket connection
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            # Connect to the printer server
            sock.connect((PRINTER_HOST, PRINTER_PORT))
            
            # Send the text data (encoded as UTF-8)
            sock.send(text.encode('utf-8'))
            
            print(f"✓ Successfully sent {len(text)} bytes to printer")
            print(f"  Text: {text.strip()}")
            
    except ConnectionRefusedError:
        print(f"✗ Error: Could not connect to {PRINTER_HOST}:{PRINTER_PORT}")
        print("  Make sure PrinterOne server is running!")
    except Exception as e:
        print(f"✗ Error: {e}")


# =============================================================================
# Example 2: Send Multi-line Text
# =============================================================================

def example_2_multiline_text():
    """Send formatted multi-line text to the printer."""
    print("\n" + "="*60)
    print("Example 2: Send Multi-line Text")
    print("="*60)
    
    # Multi-line text with formatting
    text = """
╔═══════════════════════════════════════╗
║      PrinterOne Test Print Job        ║
╚═══════════════════════════════════════╝

Date: 2026-02-12
Job ID: TEST-001

Content:
--------
This is a multi-line test print job
demonstrating PrinterOne capabilities.

Line 1: Testing line breaks
Line 2: Testing special characters !@#$%
Line 3: Testing numbers 1234567890

End of test print job.
"""
    
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.connect((PRINTER_HOST, PRINTER_PORT))
            sock.send(text.encode('utf-8'))
            
            print(f"✓ Successfully sent multi-line text ({len(text)} bytes)")
            
    except Exception as e:
        print(f"✗ Error: {e}")


# =============================================================================
# Example 3: Send Persian/Unicode Text
# =============================================================================

def example_3_persian_text():
    """Send Persian (Farsi) text to the printer.
    
    Note: PrinterOne automatically converts plain text to PDF with Unicode 
    fonts, so Persian text will display correctly.
    """
    print("\n" + "="*60)
    print("Example 3: Send Persian/Unicode Text")
    print("="*60)
    
    # Persian text (Hello World in Persian)
    persian_text = """
سلام دنیا!

این یک تست چاپ متن فارسی است.

PrinterOne از متن فارسی پشتیبانی می‌کند.

خط ۱: آزمایش اعداد فارسی ۱۲۳۴۵۶۷۸۹۰
خط ۲: آزمایش کاراکترهای خاص !@#$%

پایان تست.
"""
    
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.connect((PRINTER_HOST, PRINTER_PORT))
            # Persian text is UTF-8 encoded
            sock.send(persian_text.encode('utf-8'))
            
            print(f"✓ Successfully sent Persian text ({len(persian_text)} bytes)")
            print("  Note: Text will be converted to PDF with Unicode fonts")
            
    except Exception as e:
        print(f"✗ Error: {e}")


# =============================================================================
# Example 4: Send File Contents
# =============================================================================

def example_4_send_file(file_path=None):
    """Send the contents of a file to the printer.
    
    Args:
        file_path: Path to the file to print (default: creates a test file)
    """
    print("\n" + "="*60)
    print("Example 4: Send File Contents")
    print("="*60)
    
    # Create a test file if none provided
    if file_path is None:
        file_path = 'test_print.txt'
        test_content = """This is a test file for PrinterOne.

File: test_print.txt
Created for demonstration purposes.

Content goes here...
Line 1
Line 2
Line 3

End of file.
"""
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(test_content)
        print(f"  Created test file: {file_path}")
    
    try:
        # Read the file
        with open(file_path, 'rb') as f:
            data = f.read()
        
        # Send to printer
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.connect((PRINTER_HOST, PRINTER_PORT))
            sock.send(data)
            
        print(f"✓ Successfully sent file '{file_path}' ({len(data)} bytes)")
        
        # Clean up test file
        if file_path == 'test_print.txt':
            import os
            os.remove(file_path)
            print(f"  Cleaned up test file")
            
    except FileNotFoundError:
        print(f"✗ Error: File '{file_path}' not found")
    except Exception as e:
        print(f"✗ Error: {e}")


# =============================================================================
# Example 5: Send Data with Error Handling
# =============================================================================

def example_5_with_error_handling(text, timeout=5):
    """Send data to printer with comprehensive error handling.
    
    Args:
        text: Text to send to the printer
        timeout: Socket timeout in seconds (default: 5)
    
    Returns:
        True if successful, False otherwise
    """
    print("\n" + "="*60)
    print("Example 5: Send with Error Handling")
    print("="*60)
    
    try:
        # Create socket with timeout
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        
        # Connect to printer
        print(f"  Connecting to {PRINTER_HOST}:{PRINTER_PORT}...")
        sock.connect((PRINTER_HOST, PRINTER_PORT))
        print(f"  ✓ Connected")
        
        # Send data
        print(f"  Sending {len(text)} bytes...")
        data = text.encode('utf-8')
        sent = sock.sendall(data)
        print(f"  ✓ Data sent successfully")
        
        # Close connection
        sock.close()
        print(f"  ✓ Connection closed")
        
        return True
        
    except socket.timeout:
        print(f"  ✗ Error: Connection timeout after {timeout} seconds")
        return False
    except ConnectionRefusedError:
        print(f"  ✗ Error: Connection refused")
        print(f"     Make sure PrinterOne server is running on {PRINTER_HOST}:{PRINTER_PORT}")
        return False
    except socket.gaierror:
        print(f"  ✗ Error: Could not resolve hostname '{PRINTER_HOST}'")
        return False
    except Exception as e:
        print(f"  ✗ Error: {type(e).__name__}: {e}")
        return False


# =============================================================================
# Example 6: Reusable Print Function
# =============================================================================

class PrinterClient:
    """A reusable client class for sending data to PrinterOne server."""
    
    def __init__(self, host=PRINTER_HOST, port=PRINTER_PORT, timeout=10):
        """Initialize the printer client.
        
        Args:
            host: PrinterOne server hostname or IP address
            port: PrinterOne server port (default: 9100)
            timeout: Connection timeout in seconds (default: 10)
        """
        self.host = host
        self.port = port
        self.timeout = timeout
    
    def print_text(self, text, encoding='utf-8'):
        """Send text to the printer.
        
        Args:
            text: Text to print (string)
            encoding: Text encoding (default: utf-8)
        
        Returns:
            True if successful, False otherwise
        
        Raises:
            ConnectionError: If cannot connect to printer
            ValueError: If text is empty
        """
        if not text:
            raise ValueError("Text cannot be empty")
        
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(self.timeout)
                sock.connect((self.host, self.port))
                sock.send(text.encode(encoding))
            return True
        except Exception as e:
            raise ConnectionError(f"Failed to print: {e}")
    
    def print_file(self, file_path):
        """Send file contents to the printer.
        
        Args:
            file_path: Path to the file to print
        
        Returns:
            True if successful, False otherwise
        
        Raises:
            FileNotFoundError: If file doesn't exist
            ConnectionError: If cannot connect to printer
        """
        try:
            with open(file_path, 'rb') as f:
                data = f.read()
            
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(self.timeout)
                sock.connect((self.host, self.port))
                sock.send(data)
            return True
        except FileNotFoundError:
            raise
        except Exception as e:
            raise ConnectionError(f"Failed to print file: {e}")


def example_6_reusable_class():
    """Demonstrate using the reusable PrinterClient class."""
    print("\n" + "="*60)
    print("Example 6: Using Reusable PrinterClient Class")
    print("="*60)
    
    # Create a printer client
    printer = PrinterClient(host=PRINTER_HOST, port=PRINTER_PORT)
    
    # Example 1: Print simple text
    try:
        text = "Hello from PrinterClient class!"
        printer.print_text(text)
        print(f"✓ Printed text: '{text}'")
    except Exception as e:
        print(f"✗ Error: {e}")
    
    # Example 2: Print Persian text
    try:
        persian = "سلام از PrinterClient!"
        printer.print_text(persian)
        print(f"✓ Printed Persian text")
    except Exception as e:
        print(f"✗ Error: {e}")


# =============================================================================
# Main Function
# =============================================================================

def main():
    """Run all examples."""
    print("\n")
    print("╔" + "="*58 + "╗")
    print("║" + " "*10 + "PrinterOne - Python Client Examples" + " "*12 + "║")
    print("╚" + "="*58 + "╝")
    print(f"\nServer: {PRINTER_HOST}:{PRINTER_PORT}")
    print(f"Note: Make sure PrinterOne server is running!\n")
    
    # Run examples
    example_1_simple_text()
    example_2_multiline_text()
    example_3_persian_text()
    example_4_send_file()
    example_5_with_error_handling("Test with error handling")
    example_6_reusable_class()
    
    print("\n" + "="*60)
    print("All examples completed!")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
