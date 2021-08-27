# Design and Implementation of a 10-bit Serializer(vsdserializer_v1) in RTL2GDS flow using SKY130 pdks
*The purpose of this project is to produce clean GDS (Graphic Design System) Final Layout with all details that is used to print photomasks used in 
fabrication of a behavioral RTL (Register-Transfer Level) of a 10-bit Serializer, using SkyWater 130 nm PDK (Process Design Kit)*

# Table of Contents

1. [About The Project](#About-The-Project)
2. [Pin Configuration](#Pin-Configuration)
3. [Functional Diagram and Description](#Functional-Diagram-and-Description)
4. [RTL to GDSII Introduction](#RTL-to-GDSII-Introduction)
5. [Pre-Layout](#pre-layout)
	- [Simulation](#simulation)
6. [OpenLane](#openlane)
	- [Installation](#installation)
	- [Running OpenLane](#running-openlane)
7. [Synthesis](#synthesis)
8. [Floorplanning](#floorplanning)
9. [Placement](#placement)
10. [Routing](#routing)
11. [Final Layout](#final-layout)
13. [Post-layout](#post-layout)
	- [Simulation](#simulation)
14. [Summary](#summary)
15. [Area of improvement](#area-of-improvement)
17. [References](#references)
18. [Acknowledgement](#acknowledgement)
19. [Author](#author)


### About The Project

OpenLANE is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, Fault, OpenPhySyn, SPEF-Extractor and custom methodology 
scripts for design exploration and optimization. It is a tool started for true open source tape-out experience and comes with APACHE version 2.0. 
The goal of OpenLANE is to produce clean GDSII without any human intervention. OpenLANE is tuned for Skywater 130nm open-source PDK and can be used to produce hard macros 
and chips.


### Pin Configuration

![Pinconfiguration-1](https://user-images.githubusercontent.com/83152452/131133168-3bd63ad4-f89e-4ce3-9af6-095a93d0b173.png)

### Functional Diagram and Description

![Functionaldescription-1](https://user-images.githubusercontent.com/83152452/131133536-bbf2f774-145d-4f8f-aaa5-8d98cdd6f3f3.png)

### RTL to GDSII Introduction

From conception to product, the ASIC design flow is an iterative process that is not static for every design. The details of the flow may change depending on ECO’s, IP requirements, DFT insertion, and SDC constraints, however the base concepts still remain. The flow can be broken down into 11 steps:

1. Architectural Design – A system engineer will provide the VLSI engineer with specifications for the system that are determined through physical constraints. 
   The VLSI engineer will be required to design a circuit that meets these constraints at a microarchitecture modeling level.

2. RTL Design/Behavioral Modeling – RTL design and behavioral modeling are performed with a hardware description language (HDL). 
   EDA tools will use the HDL to perform mapping of higher-level components to the transistor level needed for physical implementation. 
   HDL modeling is normally performed using either Verilog or VHDL. One of two design methods may be employed while creating the HDL of a microarchitecture:
   
    a. RTL Design – Stands for Register Transfer Level. It provides an abstraction of the digital   circuit using:
   
   - i. 	 Combinational logic
   - ii. 	 Registers
   - iii.  Modules (IP’s or Soft Macros)
 
    b. 	Behavioral Modeling – Allows the microarchitecture modeling to be performed with behavior-based modeling in HDL. This method bridges the gap between C and HDL allowing HDL design to be performed

3. RTL Verification - Behavioral verification of design

4. DFT Insertion - Design-for-Test Circuit Insertion

5. Logic Synthesis – Logic synthesis uses the RTL netlist to perform HDL technology mapping. The synthesis process is normally performed in two major steps:

     - GTECH Mapping – Consists of mapping the HDL netlist to generic gates what are used to perform logical optimization based on AIGERs and other topologies created 
       from the generic mapped netlist.
       
     - Technology Mapping – Consists of mapping the post-optimized GTECH netlist to standard cells described in the PDK
  
6. Standard Cells – Standard cells are fixed height and a multiple of unit size width. This width is an integer multiple of the SITE size or the PR boundary. Each standard cell comes with SPICE, HDL, liberty, layout (detailed and abstract) files used by different tools at different stages in the RTL2GDS flow.

7. Post-Synthesis STA Analysis: Performs setup analysis on different path groups.

8. Floorplanning – Goal is to plan the silicon area and create a robust power distribution network (PDN) to power each of the individual components of the synthesized netlist. In addition, macro placement and blockages must be defined before placement occurs to ensure a legalized GDS file. In power planning we create the ring which is connected to the pads which brings power around the edges of the chip. We also include power straps to bring power to the middle of the chip using higher metal layers which reduces IR drop and electro-migration problem.

9. Placement – Place the standard cells on the floorplane rows, aligned with sites defined in the technology lef file. Placement is done in two steps: Global and Detailed. In Global placement tries to find optimal position for all cells but they may be overlapping and not aligned to rows, detailed placement takes the global placement and legalizes all of the placements trying to adhere to what the global placement wants.

10. CTS – Clock tree synteshsis is used to create the clock distribution network that is used to deliver the clock to all sequential elements. The main goal is to create a network with minimal skew across the chip. H-trees are a common network topology that is used to achieve this goal.

11. Routing – Implements the interconnect system between standard cells using the remaining available metal layers after CTS and PDN generation. The routing is performed on routing grids to ensure minimal DRC errors.

The Skywater 130nm PDK uses 6 metal layers to perform CTS, PDN generation, and interconnect routing. Shown below is an example of a base RTL to GDS flow in ASIC design:

![RTLtoGDSIIflow](https://user-images.githubusercontent.com/83152452/131134578-5cd34ec9-a388-476b-aa4b-914c250d7ec9.png)


### Pre-Layout

 Commands to use :
 
![prelayout-gtkwave-1](https://user-images.githubusercontent.com/83152452/131137211-affff0dd-51cb-47c4-be6a-a1b7bd00f112.png)

 Obtained GTKWave :
 
![prelayout-gtkwave](https://user-images.githubusercontent.com/83152452/131137222-28e10d51-8430-42f6-b5cb-0c86313dbb27.png)



## OpenLane 

OpenLane is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, Fault and custom methodology scripts for design exploration 
and optimization.

For more details : [here](https://openlane.readthedocs.io/)

![OpenLaneflow](https://user-images.githubusercontent.com/83152452/131135115-46148ff1-9489-48f6-a334-6702c25def59.png)


### OpenLane design stages

1. Synthesis
	- `yosys` - Performs RTL synthesis
	- `abc` - Performs technology mapping
	- `OpenSTA` - Performs static timing analysis on the resulting netlist to generate timing reports
2. Floorplan and PDN
	- `init_fp` - Defines the core area for the macro as well as the rows (used for placement) and the tracks (used for routing)
	- `ioplacer` - Places the macro input and output ports
	- `pdn` - Generates the power distribution network
	- `tapcell` - Inserts welltap and decap cells in the floorplan
3. Placement
	- `RePLace` - Performs global placement
	- `Resizer` - Performs optional optimizations on the design
	- `OpenDP` - Perfroms detailed placement to legalize the globally placed components
4. CTS
	- `TritonCTS` - Synthesizes the clock distribution network (the clock tree)
5. Routing
	- `FastRoute` - Performs global routing to generate a guide file for the detailed router
	- `CU-GR` - Another option for performing global routing.
	- `TritonRoute` - Performs detailed routing
	- `SPEF-Extractor` - Performs SPEF extraction
6. GDSII Generation
	- `Magic` - Streams out the final GDSII layout file from the routed def
	- `Klayout` - Streams out the final GDSII layout file from the routed def as a back-up
7. Checks
	- `Magic` - Performs DRC Checks & Antenna Checks
	- `Klayout` - Performs DRC Checks
	- `Netgen` - Performs LVS Checks
	- `CVC` - Performs Circuit Validity Checks



### Installation

#### Prerequisites

- Preferred Ubuntu OS)
- Docker 19.03.12+
- GNU Make
- Python 3.6+ with PIP
- Click, Pyyaml: `pip3 install pyyaml click`

```
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane/
make openlane
make pdk
make test # This a ~5 minute test that verifies that the flow and the pdk were properly installed
```

For detailed installation process, check [here](https://github.com/The-OpenROAD-Project/OpenLane)

### Running OpenLane

`make mount`
- Note
	- Default PDK_ROOT is $(pwd)/pdks. If you have installed the PDK at a different location, run the following before `make mount`:
	- Default IMAGE_NAME is efabless/openlane:current. If you want to use a different version, run the following before `make mount`:

The following is roughly what happens under the hood when you run `make mount` + the required exports:

```
export PDK_ROOT=<absolute path to where skywater-pdk and open_pdks will reside>
export IMAGE_NAME=<docker image name>
docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) $IMAGE_NAME
```

For verification :

![pdks-1](https://user-images.githubusercontent.com/83152452/131135629-f38b823f-6fae-4ee5-ba0f-745aa52f2778.png)

![Invoking OpenLane-1](https://user-images.githubusercontent.com/83152452/131135639-750ac1ef-16e0-4ba4-8941-4fd530055969.png)


###Synthesis

Command : ```run_synthesis```

![run_synthesis-1](https://user-images.githubusercontent.com/83152452/131136229-89df880a-c13b-44f5-9523-5c8c76aa6adc.png)

![run_synthesis_printing-statistics-1](https://user-images.githubusercontent.com/83152452/131136234-9ebbe1c4-1eca-4c23-83e7-5a2c6847a668.png)

Successful :

![run_synthesis_printing-statistics-parameter-2](https://user-images.githubusercontent.com/83152452/131136271-942fdd63-4987-4c9d-aafe-21d0b670bafb.png)

Command used :

![run_synthesis-circuit-1](https://user-images.githubusercontent.com/83152452/131146544-2dc1a269-8349-41a7-a308-d3c0e83d63a4.png)

Yosys synthesis :

![synthesis-1](https://user-images.githubusercontent.com/83152452/131146586-69b2f177-987a-4b1c-9efc-1cfd03b21200.png)


### Floorplanning

```

# User config
set ::env(DESIGN_NAME) vsdserializer_v1

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) 10
set ::env(CLOCK_PORT) "clk"

set ::env(FP_CORE_UTIL) 25
set ::env(PL_TARGET_DENSITY) 1

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

```

 Command used : ``` run_floorplan ```
 
![floorplan-2](https://user-images.githubusercontent.com/83152452/131153350-7bbf7522-ffd1-4af9-9aa8-379e88e86772.png)


For invoking : 

![floorplan-3](https://user-images.githubusercontent.com/83152452/131144577-45389253-5576-47f8-9321-d79ea0b33893.png)

Floorplanning viewed :

![floorplan-1](https://user-images.githubusercontent.com/83152452/131141794-3c6dd5cf-9009-4e4e-9ba3-e4bd9971a358.png)


### Placement

Command : ``` run_placement ```

Placement analysis :

![run_placement_analysis-1](https://user-images.githubusercontent.com/83152452/131145484-19d88c19-9d49-4ced-906c-33c7c7246fd8.png)

![run_placement_analysis-2](https://user-images.githubusercontent.com/83152452/131145526-5693ad80-f716-4769-8836-6569149edb57.png)

Placement routing resources :

![run_placement-routing-resources-1](https://user-images.githubusercontent.com/83152452/131145451-3733862f-48d9-4538-b94f-b6dde8af6c44.png)

Final Congestion report :

![run_placement-final-congestion-report-1](https://user-images.githubusercontent.com/83152452/131145469-a50fed70-563c-485f-b586-86c9825f4654.png)


And then run the following command :

![placement-command-1](https://user-images.githubusercontent.com/83152452/131146168-9afbd321-a787-4d67-99da-60b1e5f3fc0e.png)


To obtain :

![magic-placement-1](https://user-images.githubusercontent.com/83152452/131149028-d55f7930-e386-49ad-a245-f7e472a5e60f.png)



### Routing

Command used : ``` run_routing ```

Routing resources analysis :

![rounting1](https://user-images.githubusercontent.com/83152452/131148411-7f6225ee-cb40-41b7-99a8-c18c144cb4e0.png)


Final Congestion report :

![routing_finalcongestionreport](https://user-images.githubusercontent.com/83152452/131148422-bb0b75c9-b9bb-4b71-ba4c-1a9a78a3dc75.png)


Completed detail routing :

![routing_completedetailrouting](https://user-images.githubusercontent.com/83152452/131148724-a22bd5f2-bf78-49a7-84b5-168bdc895f65.png)


Routing successful :

![routing_successful](https://user-images.githubusercontent.com/83152452/131148429-bd93be63-4104-4abc-8445-88089f867776.png)


### Final Layout

![placement-2](https://user-images.githubusercontent.com/83152452/131149008-b3ae9fa9-d38a-4fdd-8ec0-2f26ff3a500b.png)


## Post Layout 

### Simulation

Commands used :

![postlayout-command1](https://user-images.githubusercontent.com/83152452/131149762-ff96bb08-2683-487a-8eec-da12af4d1071.png)

GTKWave obtained :

![prelayout-gtkwave](https://user-images.githubusercontent.com/83152452/131149782-4165e07f-9cdb-4212-b4f7-7795617d8147.png)



### Summary

Clone it using the command : ``` https://github.com/Devipriya1921/vsdserializer_v1.git ```


- Complete details can be found in the design folder :


```

vsdserializer_v1
├── config.tcl
├── runs
│   ├── first_run
│   │   ├── config.tcl
│   │   ├── logs
│   │   │   ├── cts
│   │   │   ├── cvc
│   │   │   ├── floorplan
│   │   │   ├── klayout
│   │   │   ├── magic
│   │   │   ├── placement
│   │   │   ├── routing
│   │   │   └── synthesis
│   │   ├── reports
│   │   │   ├── cts
│   │   │   ├── cvc
│   │   │   ├── floorplan
│   │   │   ├── klayout
│   │   │   ├── magic
│   │   │   ├── placement
│   │   │   ├── routing
│   │   │   └── synthesis
│   │   ├── results
│   │   │   ├── cts
│   │   │   ├── cvc
│   │   │   ├── floorplan
│   │   │   ├── klayout
│   │   │   ├── magic
│   │   │   ├── placement
│   │   │   ├── routing
│   │   │   └── synthesis
│   │   └── tmp
│   │       ├── cts
│   │       ├── cvc
│   │       ├── floorplan
│   │       ├── klayout
│   │       ├── magic
│   │       ├── placement
│   │       ├── routing
│   │       └── synthesis
├── src
|   ├── vsdserializer_v1.v
├── pre_layout
|   ├── vsdserializer_v1
|   ├── vsdserializer_v1.v
|   ├── vsdserializer_v1.v.vcd
|   ├── vsdserializer_v1_tb.v
|   ├── vsdserializer_v1_tb.vcd
├── post_layout
|   ├── gls
|   ├── gls.v
|   ├── primitives.v
|   ├── sky130_fd_sc_hd.v
|   ├── vsdserializer_v1.synthesis.v
|   ├── vsdserializer_v1_vcd
|   ├── vsdserializer_v1_tb.vcd

   
```

### Area of improvement

- Improvement in the design and integration of Power pins.
- To perform spice simulation of the final GDS layout.

## References

- [GitLab/OpenLane workshop](https://gitlab.com/gab13c/openlane-workshop)
- [The OpenROAD Project/OpenLane](https://github.com/The-OpenROAD-Project/OpenLane)
- https://youtu.be/d0hPdkYg5QI

## Acknowledgement

- [Kunal Ghosh](https://github.com/kunalg123), Founder, VSD Corp. Pvt. Ltd

## Author

- [A Devipriya](https://github.com/Devipriya1921), Bachelor of Engineering in Electronics and Communication Engineering, Cambridge Institute of Technology, Bangalore





