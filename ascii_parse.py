#!/usr/bin/env python3
import sys

def ascii_to_text(ascii_string):
    # Split the input string into a list of ASCII codes
    ascii_codes = ascii_string.split()
    # Convert each ASCII code to its corresponding character and join them into a string
    text = ''.join(chr(int(code)) for code in ascii_codes)
    return text

# Example usage
if __name__ == "__main__":
    # Check if command-line arguments are provided
    if len(sys.argv) > 1:
        # Join all command-line arguments into a single string
        ascii_input = ' '.join(sys.argv[1:])
        result = ascii_to_text(ascii_input)
        print("Translated text:", result)
    else:
        # If no command-line arguments, prompt for input
        ascii_input = input("Enter ASCII codes separated by spaces: ")
        result = ascii_to_text(ascii_input)
        print("Translated text:", result)