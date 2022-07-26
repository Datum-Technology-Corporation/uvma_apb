#! /bin/bash
#######################################################################################################################
## Copyright 2021-2022 Datum Technology Corporation
## SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#######################################################################################################################


# Launched from uvma_apb project sim dir
mio sim     uvmt_apb_st -CE
mio sim     uvmt_apb_st -S -t reads      -s 1 -c
mio sim     uvmt_apb_st -S -t writes     -s 1 -c
mio sim     uvmt_apb_st -S -t all_access -s 1 -c
mio results uvmt_apb_st results
mio cov     uvmt_apb_st
