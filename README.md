# 32-bit Integer Multiplication Program

## Description

This program multiplies two 32-bit integers and displays the result in both binary and decimal formats. It reads the input values from a binary file (`INT2.BIN`) and processes the multiplication using MIPS assembly language. The program handles both positive and negative numbers and provides a detailed decimal output by converting the binary result to a human-readable decimal format.

## Program Details

### Data Segment

- **dulieu1**: 8 bytes reserved for the first integer input.
- **dulieu2**: 8 bytes reserved for the second integer input.
- **dulieu1_hi**: Stores the upper 32 bits of the first integer.
- **output_hi**: Stores the upper 32 bits of the multiplication result.
- **output_lo**: Stores the lower 32 bits of the multiplication result.
- **dau**: Stores the sign of the multiplication result.
- **ans**: 30 bytes reserved for the final decimal result.
- **ans_tmp**: Temporary variable for decimal result processing.
- **base**: Stores the current base value during decimal conversion.
- **base_tmp**: Temporary variable for base processing.

### Code Segment

The program consists of the following key parts:

1. **Input Handling**: The program opens the binary file `INT2.BIN`, reads the two 32-bit integers into `dulieu1` and `dulieu2`, and then closes the file.

2. **Multiplication**: The multiplication of the two integers is performed using the `Multi32` function, which handles the 64-bit result. The sign of the result is determined, and appropriate adjustments are made for negative values.

3. **Binary Output**: The program first outputs the binary representation of the multiplication result.

4. **Decimal Conversion**: The program then converts the binary result into a decimal format, updating the `ans` variable with the final decimal value.

5. **Output**: The final results in both binary and decimal formats are printed to the console.

### Functions

- **Multi32**: Multiplies two 32-bit integers and returns a 64-bit result split into `output_hi` and `output_lo`.
- **Xuat_kq**: Outputs the binary result of the multiplication.
- **Xuat_kq_decimal**: Converts the binary result to decimal and outputs it.

## Usage

1. Prepare a binary file named `INT2.BIN` containing the two 32-bit integers to be multiplied.
2. Run the program in a MIPS simulator or on a compatible hardware platform.
3. The program will output the binary and decimal results of the multiplication.

## Error Handling

If there is an issue opening the file `INT2.BIN`, the program will print an error message and terminate.

## Example Output

### Example 1: 45 x 56
```
Du lieu 1 = 45  
Du lieu 2 = 56  
Ket qua sau khi nhan he 2 la: 000000000000000000000000000000000001010011011000  
Ket qua sau khi nhan he 10 la: 2520

-- program is finished running --
```

### Example 2: 1234567897 x 223123124
```
Du lieu 1 = 1234567897
Du lieu 2 = 223123124
Ket qua sau khi nhan he 2 la: 0000001110010110101100000111111110111101000000110001000010010100
Ket qua sau khi nhan he 10 la: 275460645968750228

-- program is finished running --
```

### Example 3: 78945225 x 55445562
```
Du lieu 1 = 78945225
Du lieu 2 = 55445562
Ket qua sau khi nhan he 2 la: 0000000010111010000101000011000001100000000011010011001100101010
Ket qua sau khi nhan he 10 la: 4377162367341450

-- program is finished running --
```

