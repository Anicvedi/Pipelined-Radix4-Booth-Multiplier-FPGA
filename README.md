# Signed 8-Bit Pipelined Radix-4 Booth Multiplier & Asynchronous CDC Debouncer Subsystem

[![Verilog HDL](https://img.shields.io/badge/Language-Verilog_HDL-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Target](https://img.shields.io/badge/FPGA-Xilinx_Artix--7_XC7A35T-red.svg)](https://www.xilinx.com)
[![Frequency Boost](https://img.shields.io/badge/f_max_Boost-+77.8%25-brightgreen.svg)]()
[![Course](https://img.shields.io/badge/Course-E3_231_Digital_Systems_Design_with_FPGAs-purple.svg)](https://iisc.ac.in)

Author: **Anirudh Chaturvedi** (SR: 25850)  
M.Tech in Microelectronics & VLSI Design, Indian Institute of Science (IISc), Bangalore  
Department of Electronic Systems Engineering (DESE)

---

## 1. Project Overview

This repository presents the microarchitectural design, synthesis, and physical FPGA implementation of:
1. **5-Stage Pipelined Signed 8-bit Radix-4 Booth Multiplier** with Carry-Save Adder (CSA) reduction trees.
2. **Asynchronous Input Conditioning Subsystem** featuring a 2-stage D-FF Clock-Domain Crossing (CDC) synchronizer chain and counter-based debouncer FSM driving a parameterized synchronous Mod-N up/down counter.

---

## 2. Radix-4 Booth Recoding & Pipelining

Radix-4 Booth recoding inspects multiplier bits in overlapping triplets $\{y_{2i+1}, y_{2i}, y_{2i-1}\}$ to halve the number of partial products from 8 down to 4:
$$PP_i \in \{0, \pm X, \pm 2X\}$$

### Pipelining Comparison on Artix-7 (`XC7A35T`)
By inserting balanced pipeline registers between Booth recoding, CSA reduction stages, and final vector-merge addition:

| Metric | Unpipelined Multiplier | 5-Stage Pipelined Multiplier | Relative Gain |
| :--- | :---: | :---: | :---: |
| **Critical Path Delay ($T_{crit}$)** | $6.58	ext{ ns}$ | **$3.701	ext{ ns}$** | **$-43.8\%$ Delay** |
| **Max Frequency ($f_{max}$)** | $152.0	ext{ MHz}$ | **$270.2	ext{ MHz}$** | **$+77.8\%$ Boost** |
| **Setup Slack ($WNS$ @ 100 MHz)** | $+3.420	ext{ ns}$ | **$+6.299	ext{ ns}$** | **$+2.88	ext{ ns}$ Slack Margin** |
| **Latency** | 2 clock cycles | 5 clock cycles | 5 cycles pipelined |
| **Throughput** | 1 result / $6.58	ext{ ns}$ | **1 result / $3.70	ext{ ns}$** | **$1.78	imes$ Throughput** |

---

## 3. Asynchronous Input Debouncer & CDC Subsystem

Mechanical pushbuttons and switches suffer from contact bounce ($5 - 20	ext{ ms}$) and introduce severe metastability hazards when sampled across asynchronous clock boundaries.

- **2-Stage Synchronizer Chain:** Eliminates metastability via cascaded D flip-flops with high Mean Time Between Failures (MTBF).
- **Debouncer FSM:** Integrates a parameterized threshold counter that confirms input stability before asserting a single-cycle clean pulse.
- **Hardware Validation:** Verified on Basys 3 board driving a Mod-N counter ($WNS = +6.420	ext{ ns}$, $f_{max} pprox 279.3	ext{ MHz}$).

Complete timing summaries and verification reports are included in [`docs/LAB4_Pipelining_and_Debouncing_Report.pdf`](docs/LAB4_Pipelining_and_Debouncing_Report.pdf) and [`docs/Guide_6_Booth_and_Approximate_Multipliers.pdf`](docs/Guide_6_Booth_and_Approximate_Multipliers.pdf).
