# Secure Data Hiding Using AI and QR Codes

A steganographic system for securely hiding and retrieving data using QR codes, combining image processing techniques with AI concepts to improve security and accuracy.

## Features
- Embeds hidden data into an image using steganography
- Extracts hidden data back from the image
- QR code generation and scanning to carry/retrieve data

## Technologies Used
- MATLAB (embedding and extraction logic)
- Python (QR code scanning)
- Image Processing
- Artificial Intelligence concepts

## Files
- `embed_and_extract.m` — MATLAB script for embedding and extracting hidden data in an image
- `scan_qr.py` — Python script for scanning and reading QR codes
- `input.png`, `qr.png` — sample images used by the system

## How It Works
Data is hidden within the pixels of an image using image-processing-based steganography techniques. A QR code is used as a carrier/reference, which can be scanned to help retrieve or verify the hidden information.
