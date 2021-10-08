# About
## [Home Page](https://datum-technology-corporation.github.io/uvma_apb/)
The Moore.io UVM APB Agent is a compact, sequence-based solution to Driving/Monitoring both sides of the interface.  This project consists of the agent (`uvma_apb_pkg`), the self-testing UVM environment (`uvme_apb_st_pkg`) and the test bench (`uvmt_apb_st_pkg`) to verify the agent against itself.

## IP
* DV
> * uvma_apb
> * uvme_apb_st
> * uvmt_apb_st
* RTL
* Tools


# Simulation
```
cd ./sim
cat ./README.md
./setup_project.py
source ./setup_terminal.sh
export VIVADO=/path/to/vivado/install
dvm --help
clear && dvm all uvmt_apb_st -t all_access -s 1 -w
```
