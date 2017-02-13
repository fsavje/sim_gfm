#!/bin/bash

source ../global_env.sh

$TIME -f "%S %U %M" $@ 2>&1
