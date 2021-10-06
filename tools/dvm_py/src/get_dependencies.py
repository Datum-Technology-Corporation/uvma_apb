#! /usr/bin/python3 
########################################################################################################################
## Copyright 2021 Datum Technology Corporation
########################################################################################################################
## SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
## Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
## with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
##                                        https://solderpad.org/licenses/SHL-2.1/
## Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
## an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations under the License.
########################################################################################################################


import dvm

def do_update():
    print("No dependencies for this target")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "main"   , "uvml_sb")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "main"   , "uvml_hrtbt")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "main"   , "uvml_trn")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "main"   , "uvma_clk")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "main"   , "uvml_ral")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "main"   , "uvma_reset")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "main"   , "uvml_logs")
    #clone_repo_dv_to_imports("https://github.com/Datum-Technology-Corporation/mio_ip_core.git", "uvml_io", "uvml_io")


def do_paths():
    
    ### RTL ###
    
    ### DV ###
    # Libraries
    dvm.set_env_var("UVM_HOME"                 , dvm.dv_imports_path + "/uvm"                   )
    dvm.set_env_var("DV_UVM_SRC_PATH"          , dvm.dv_imports_path + "/uvm"           + "/src")
    dvm.set_env_var("DV_UVML_SRC_PATH"         , dvm.dv_imports_path + "/uvml"          + "/src")
    dvm.set_env_var("DV_UVMA_ST_SRC_PATH"      , dvm.dv_imports_path + "/uvma_st"       + "/src")
    dvm.set_env_var("DV_UVME_ST_SRC_PATH"      , dvm.dv_imports_path + "/uvme_st"       + "/src")
    dvm.set_env_var("DV_UVMT_ST_SRC_PATH"      , dvm.dv_imports_path + "/uvmt_st"       + "/src")
    dvm.set_env_var("DV_UVML_LOGS_SRC_PATH"    , dvm.dv_imports_path + "/uvml_logs"     + "/src")
    dvm.set_env_var("DV_UVML_SB_SRC_PATH"      , dvm.dv_imports_path + "/uvml_sb"       + "/src")
    dvm.set_env_var("DV_UVML_RAL_SRC_PATH"     , dvm.dv_imports_path + "/uvml_ral"      + "/src")
    dvm.set_env_var("DV_UVMA_RESET_SRC_PATH"   , dvm.dv_imports_path + "/uvma_reset"    + "/src")
    dvm.set_env_var("DV_UVME_RESET_ST_SRC_PATH", dvm.dv_imports_path + "/uvme_reset_st" + "/src")
    dvm.set_env_var("DV_UVMT_RESET_ST_SRC_PATH", dvm.dv_imports_path + "/uvmt_reset_st" + "/src")
    dvm.set_env_var("DV_UVMA_CLK_SRC_PATH"     , dvm.dv_imports_path + "/uvma_clk"      + "/src")
    dvm.set_env_var("DV_UVME_CLK_ST_SRC_PATH"  , dvm.dv_imports_path + "/uvme_clk_st"   + "/src")
    dvm.set_env_var("DV_UVMT_CLK_ST_SRC_PATH"  , dvm.dv_imports_path + "/uvmt_clk_st"   + "/src")
    
    # Source
    dvm.set_env_var("DV_UVML_SRC_PATH"   , dvm.dv_path + "/uvml"    + "/src")
    dvm.set_env_var("DV_UVMA_ST_SRC_PATH", dvm.dv_path + "/uvma_st" + "/src")
    dvm.set_env_var("DV_UVME_ST_SRC_PATH", dvm.dv_path + "/uvme_st" + "/src")
    dvm.set_env_var("DV_UVMT_ST_SRC_PATH", dvm.dv_path + "/uvmt_st" + "/src")
