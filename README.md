# FIFO Buffer 

## Purpose
This project implements a First-In-First-Out (FIFO) buffer in VHDL. A FIFO buffer is a data structure that follows the "first in, first out" principle, where the first element added to the queue will be the first one to be removed. Furthermore, the FIFO :
- Buffers data between a producer (writing data to the FIFO) and a consumer (reading data from the FIFO).
- Handles different data rates between two systems, providing a mechanism to prevent data overflow (when the producer is faster) or underflow (when the consumer is faster).
- Ensures proper data sequencing, so the data is read in the same order it was written.

## Features
- Configurable data width and FIFO depth
- Write and read operations
- Status signals: empty, full, almost empty, almost full
- Occupancy indicator
- Reset functionality

## Implementation 

### Entity: FIFObuffer
The main entity `FIFObuffer` has the following ports:
- Clock and reset inputs
- Write interface: write enable and data input
- Read interface: read enable and data output
- Status signals: empty, full, almost_empty, almost_full
- Debug signal: occupancy

### Key Processes

1. **Write Process (`write_proc`)**
   - Handles writing data into the FIFO
   - Increments the write pointer
   - Only writes when write enable is high and FIFO is not full

2. **Read Process (`read_proc`)**
   - Handles reading data from the FIFO
   - Increments the read pointer
   - Only reads when read enable is high and FIFO is not empty

3. **Count Process (`count_proc`)**
   - Manages the count of elements in the FIFO
   - Increments count on write, decrements on read
   - Handles simultaneous read and write operations

### Status Signals
- `empty`: Asserted when count is 0
- `full`: Asserted when count equals FIFO depth
- `almost_empty`: Asserted when count is less than or equal to ALMOST_EMPTY_THRESHOLD
- `almost_full`: Asserted when count is greater than or equal to ALMOST_FULL_THRESHOLD
- `occupancy`: Indicates the current number of elements in the FIFO

## Testbench

The testbench (`FIFObufferTB`) verifies the functionality of the FIFO buffer under various conditions:

1. **Reset Test**
   - Applies reset and checks if FIFO is empty

2. **Write Operation Test**
   - Writes data until FIFO is full
   - Verifies full flag

3. **Read Operation Test**
   - Reads data until FIFO is empty
   - Verifies empty flag
   - Checks if read data matches written data

4. **Almost Full/Empty Test**
   - Fills FIFO to almost full state
   - Verifies almost_full flag
   - Empties FIFO to almost empty state
   - Verifies almost_empty flag

## Waveform Analysis

The project also contains a .wcfg file that  demonstrates the following behaviors:

1. **Write Operation**
   - `wr_data` incrementing from 0 to 15
   - `write_ptr` incrementing with each write
   - `count` increasing until FIFO is full

2. **Read Operation**
   - `rd_data` showing correct values being read out
   - `read_ptr` incrementing with each read
   - `count` decreasing as elements are read

3. **Status Signals**
   - `full` and `empty` flags asserting at appropriate times
   - `almost_full` and `almost_empty` flags changing based on occupancy


