# SPI Slave with Single Port RAM

A Verilog HDL implementation of an SPI slave device with integrated memory storage, optimized for FPGA deployment with comprehensive timing analysis across multiple state encoding techniques.

## 🚀 Project Overview

This repository contains a complete digital design implementing an SPI (Serial Peripheral Interface) slave module coupled with internal single-port RAM. The design enables external SPI masters to perform read/write operations on the slave's memory through standard SPI communication protocol, making it ideal for embedded systems requiring reliable data storage and retrieval capabilities.

## ✨ Key Features

- **Standards-Compliant SPI Protocol**: Implements complete SPI slave functionality with proper timing
- **Built-in Memory Storage**: On-chip single-port RAM for data persistence and retrieval
- **Clock-Synchronized Operations**: All transactions maintain strict timing alignment with master clock
- **Full-Duplex Communication**: Supports simultaneous data exchange over dedicated MISO/MOSI lines  
- **Resource-Efficient Design**: Optimized for minimal FPGA footprint and power consumption
- **Configurable Memory Depth**: Easily scalable RAM size to meet application requirements

## 📡 Signal Interface

| Signal | Direction | Description |
|--------|-----------|-------------|
| `MOSI` | Input | Master Out Slave In - Transmits data from master to slave |
| `MISO` | Output | Master In Slave Out - Transmits data from slave to master |
| `CLK` | Input | Clock signal from master for synchronizing data transfers |
| `SS` | Input | Slave Select - Signal used by master to activate the slave device |

## 🔄 Operation Flow

1. **Device Selection**: Master activates slave by asserting chip select (SS) signal
2. **Command Decoding**: Slave interprets incoming command bits to determine read/write operation  
3. **Address Transfer**: Target memory address is received and validated
4. **Data Processing**: 
   - **Write Mode**: Incoming data is stored at specified memory location
   - **Read Mode**: Requested data is retrieved from memory and queued for transmission
5. **Response Generation**: For read operations, data is shifted out via MISO synchronously
6. **Transaction End**: SS deassertion completes the communication cycle

## 🏗️ Architecture

The design consists of three main components:

- **Single Port RAM**: Memory module for data storage
- **SPI Core**: Handles SPI protocol communication
- **SPI Wrapper**: Top-level module integrating all components

## 📊 Performance Analysis

The design has been evaluated under different state encoding schemes to achieve optimal performance:

| Encoding Technique | Setup Time Slack | Hold Time Slack |
|--------------------|------------------|-----------------|
| One Hot           | 6.645 ns         | 0.075 ns        |
| Gray              | 6.580 ns         | 0.105 ns        |
| Sequential        | 6.549 ns         | 0.057 ns        |

**Result**: One-hot encoding provides the best setup and hold time slack, allowing operation at the highest frequency possible.

## 🛠️ Tools & Technologies

- **HDL**: Verilog
- **Synthesis Tool**: Xilinx Vivado
- **Target Platform**: FPGA (Xilinx)
- **Simulation**: Questa Sim

## 👨‍💻 Author

**Abdalrhman Mohy**
