#! /bin/bash
## Copyright 2021 Datum Technology Corporation
#######################################################################################################################
## SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
## Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
## with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
##                                        https://solderpad.org/licenses/SHL-2.1/
## Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
## an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations under the License.
#######################################################################################################################


# Launched from uvml project sim dir
./setup_project.py
source ./setup_terminal.sh
../tools/.imports/mio/src/mio.py cpel uvmt_apb_st
../tools/.imports/mio/src/mio.py sim uvmt_apb_st -t reads -s 1 -c
../tools/.imports/mio/src/mio.py sim uvmt_apb_st -t writes -s 1 -c
../tools/.imports/mio/src/mio.py sim uvmt_apb_st -t all_access -s 1 -c
../tools/.imports/mio/src/mio.py results uvmt_apb_st results
#../tools/.imports/mio/src/mio.py cov uvmt_apb_st
