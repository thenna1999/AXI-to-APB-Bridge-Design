AXI to APB Bridge
Overview

This project implements an AXI to APB Bridge supporting a single AXI master and 10 APB slaves. The design enables efficient protocol conversion between high-performance AXI and low-power APB domains.

Features
AXI to APB protocol conversion
Address decoding and slave selection
Multi-channel FIFO buffering
Clock domain synchronization
Modular and scalable architecture
Individual testbench for each module

Modules
1. AXI Slave Interface
Handles AXI transactions including read/write address, data, and response channels.

2. Pulse Synchronizer
Ensures safe signal transfer across different clock domains.

3. FIFO (Four Channels)
Dedicated FIFOs for AXI channels to manage data flow and timing differences.

4. Top FIFO
Central FIFO for buffering transactions at the top level.

5. Dual Port SRAM
Memory block used for temporary storage and concurrent access.

6. Address Calculator
Generates APB address mapping based on AXI transactions.

7. CSR (Control & Status Register)
Stores configuration and status information.

8. Slave Selector
Selects one of the 10 APB slaves based on address decoding.

9. SRAM Synchronizer
Handles synchronization for SRAM access across clock domains.

10. FIFO Synchronizer
Ensures safe FIFO operation between different clocks.

11. Access Arbiter
Controls access to shared resources and manages transaction priority.

12. APB Master Interface
Drives APB protocol signals to communicate with slave devices.

13. Top Module
Integrates all submodules to form the complete AXI to APB bridge system.

Verification
Each module is verified with an individual testbench
Functional validation of protocol conversion and data transfer
Ensures correctness across different scenarios

Tools & Languages
Verilog 
Simulation tools (Questa)

Future Improvements
UVM-based verification
Performance optimization
Support for multiple AXI masters
