import sys

def separate_lines(input_file):
    with open(input_file, 'rb') as f:
        lines = f.readlines()
    
    num_lines = len(lines)
    
    with open('group_0.bin', 'wb') as f0, \
         open('group_1.bin', 'wb') as f1, \
         open('group_2.bin', 'wb') as f2, \
         open('group_3.bin', 'wb') as f3:
        
        for i in range(num_lines):
            if i % 4 == 0:
                f0.write(lines[i])
            elif i % 4 == 1:
                f1.write(lines[i])
            elif i % 4 == 2:
                f2.write(lines[i])
            elif i % 4 == 3:
                f3.write(lines[i])

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./separate_files input_file")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    separate_lines(input_file)