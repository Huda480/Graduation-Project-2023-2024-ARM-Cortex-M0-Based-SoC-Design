# Graduation Project 2023/2024

## SoC Design and Integration with ARM Cortex-M0

This repository contains the complete design and integration of a
System-on-Chip (SoC) developed as a graduation project for the academic
year 2023/2024.

The goal of the project is to design, integrate, simulate, and validate
a configurable SoC based on an ARM Cortex-M0 processor with multiple
peripherals and communication modules.

------------------------------------------------------------------------

# Project Overview

The SoC integrates the following components:

-   ARM Cortex-M0 Core
-   Timers
-   Dual Timer
-   UART
-   SPI
-   GPIO
-   AHB2APB Bridge
-   RAMs
-   WiFi Module
-   BLE Module
-   Compressor
-   Decompressor (planned for future integration)

The full system model instantiates the top module twice with different
parameter configurations:

1.  Configuration 1:
    -   All peripherals enabled
    -   WITHOUT WiFi
    -   WITH Compressor
2.  Configuration 2:
    -   All peripherals enabled
    -   WITH WiFi
    -   WITH Decompressor

This allows testing and validating different SoC configurations using
parameterized RTL design.

------------------------------------------------------------------------

# Repository Structure

## image/

Contains text files representing the input image data to be compressed
by the compressor IP.

------------------------------------------------------------------------

## syn_cons/

Contains synthesis constraint files used during timing and
implementation stages.

------------------------------------------------------------------------

## Program/

Contains firmware files used to run programs on the SoC hardware. This
folder includes an internal README file with instructions for building
and running the firmware.

------------------------------------------------------------------------

## RTL/

Contains all System Verilog hardware source files for: 
- Individual IPs 
- Chip-level integration 
- Full system integration

This is the main hardware design directory.

### ✅ Summary
- **APB Subsystem**: Bridge, timers, SPI, UART, watchdog, subsystem top.  
- **AHB Peripherals**: GPIO, compressor, DMA, memory, BLE PHY, WiFi PHY, RCC.  
- **Bus Matrix**: Multiple configurations (BLE, COMP, DMA, PHY).  
- **Cortex Core**: ARM Cortex‑M0 integration logic.  
- **Top Modules**: `SYSTEM_TOP.sv` and `full_system.sv`.  
- **Testbench**: `full_system_tb.sv` for simulation.

------------------------------------------------------------------------

## scripts/

Contains simulation DO files used with QuestaSim for:

-   Running individual IP testbenches
-   Running system-level simulations
-   Running configurable system variants (WiFi-enabled, DMA-enabled,
    Compressor-enabled, etc.)
-   Running the full system configurations

These scripts automate compilation and simulation flows.

------------------------------------------------------------------------

## sim_scratch/

Workspace folder used for creating simulation projects in QuestaSim.
Contains guide text files explaining: 
- How to create a simulation project 
- How to use DO files from the scripts/ folder

------------------------------------------------------------------------
## Binary Directories

The directories `sys_1_bin/` and `sys_2_bin/` are required to run the system.  
Please create these directories in your project root and place your `.bin` files inside them.

- `sys_1_bin/` → Binary files for **System Configuration 1**
- `sys_2_bin/` → Binary files for **System Configuration 2**

Alternatively, you can change the parameter for the program path directly in the `full_system.sv` file to point to your own binary file locations.

------------------------------------------------------------------------

## Testbench/

Contains all testbenches for:

-   Complete SoC
-   Single chip configuration
-   Individual IPs (e.g., bridge_tb, etc.)

Used for functional verification.

------------------------------------------------------------------------

## unisim/

Contains required simulation libraries needed to compile VHDL files
for: 
- BLE module 
- WiFi module

------------------------------------------------------------------------

# Tools Used

-   System Verilog
-   ARM Cortex-M0
-   QuestaSim
-   Vivado Synthesis Tool (for netlist generation)
-   Embedded C for firmware development

------------------------------------------------------------------------

# Project Highlights

-   Parameterized SoC design
-   Modular IP-based architecture
-   Multi-configuration system modeling
-   Firmware + Hardware co-design
-   Compression integration

------------------------------------------------------------------------

# Notes

-   The firmware documentation is available inside the Program/ folder.
-   Simulation is primarily performed using the DO scripts inside the scripts/ directory.
-   Separate system binaries are used for each configuration.

------------------------------------------------------------------------

# Authors

Graduation Project Team\
    Bassel Yasser Hussein Dahshan

    Ahmed Ramdan Atia Mansour

    Kareem Mamdouh Hassan Ibrahim

    Marwan Ahmed Ali Ahmed

    Ibrahim Hossam Ibrahim Mansour

    Huda Abd El-Nasser Taalab Haridy

    Sherin Sameh Abd El-Samad Ali

    Nadeen Ayman Mohamed Saied

Electronics & Communication Engineering - Ain Shams University\
Academic Year 2023/2024

ITI Team\
    Abdulrahman Galal
    
    Ibrahim Yasser
