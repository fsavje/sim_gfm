#!/bin/bash

if [ ! -e "global_env.sh" ]; then
	cp global_env.sample.sh global_env.sh
fi

if [ ! -e "balance/env.sh" ]; then
	cp balance/env.sample.sh balance/env.sh
fi
