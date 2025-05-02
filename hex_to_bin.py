#!/usr/bin/env python3
import sys

def hex_to_binary(hex_string):
    # Remove any spaces and '0x' prefixes from the input
    hex_string = hex_string.replace(' ', '').replace('0x', '')
    
    # Convert each hexadecimal character to its 4-bit binary representation
    binary_result = ""
    for char in hex_string:
        # Convert hex char to integer, then to binary, then remove '0b' prefix
        # and pad to ensure 4 bits per hex digit
        binary_char = bin(int(char, 16))[2:].zfill(4)
        binary_result += binary_char + " "  # Add space between 4-bit groups
    
    return binary_result.strip()

# Example usage
if __name__ == "__main__":
    # Check if command-line arguments are provided
    if len(sys.argv) > 1:
        # Join all command-line arguments into a single string
        hex_input = ' '.join(sys.argv[1:])
        result = hex_to_binary(hex_input)
        print("Binary representation:", result)
    else:
        # If no command-line arguments, prompt for input
        hex_input = input("Enter hexadecimal values (with or without spaces): ")
        result = hex_to_binary(hex_input)
        print("Binary representation:", result)