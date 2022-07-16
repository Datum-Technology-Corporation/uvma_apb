#! /bin/bash
#######################################################################################################################
## Copyright 2021 Datum Technology Corporation
## SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#######################################################################################################################


# Launched from uvml project sim dir
shopt -s expand_aliases
source ~/.bashrc
mio cpel    uvmt_apb_st
mio sim     uvmt_apb_st -t reads      -s 1 -c
mio sim     uvmt_apb_st -t writes     -s 1 -c
mio sim     uvmt_apb_st -t all_access -s 1 -c
mio results uvmt_apb_st results
mio cov     uvmt_apb_st
