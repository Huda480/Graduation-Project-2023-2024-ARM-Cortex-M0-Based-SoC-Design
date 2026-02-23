import sys

def insert_newlines(input_file, output_file):
    with open(input_file, 'rb') as f_in:
        with open(output_file, 'wb') as f_out:
            bits_count = 0
            while True:
                byte = f_in.read(1)
                if not byte:
                    break
                byte = ord(byte)  # Convert byte to integer
                for i in range(8):
                    bit = (byte >> (7 - i)) & 1  # Extract each bit
                    f_out.write(b'1' if bit else b'0')  # Write the bit to the output file
                    bits_count += 1
                    if bits_count == 8:  # If 8 bits have been written
                        f_out.write(b'\n')  # Insert a newline
                        bits_count = 0

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script_name.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    insert_newlines(input_file, output_file)
    print("Newlines inserted successfully.")