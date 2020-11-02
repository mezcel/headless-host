#!/bin/bash

exe=$(dmenu_run -fn 'Sans Mono-9' -nb '#000000' -nf '#EEEEEE' -sb '#FFFFFF' -sf '#000000') && eval "exec $exe"
