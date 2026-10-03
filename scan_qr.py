import cv2
from pyzbar.pyzbar import decode
import os

def decode_qr():
    file_path = "recovered_qr.png"

    if not os.path.exists(file_path):
        print(f"Error: '{file_path}' not found! Run the MATLAB script first.")
        return

    img = cv2.imread(file_path)
    if img is None:
        print("Error: Could not read image.")
        return

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    decoded_objects = decode(gray)

    if not decoded_objects:
        print("No QR Code detected! Check the extraction quality.")
    else:
        print("\n=== SUCCESS: QR CODE DECODED ===")
        for obj in decoded_objects:
            print(f"Decoded Data: {obj.data.decode('utf-8')}")

if __name__ == "__main__":
    decode_qr()