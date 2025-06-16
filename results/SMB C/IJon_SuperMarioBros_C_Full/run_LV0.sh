#!/bin/bash

timeout 12h ../ijon-experimental/afl-fuzz -M ijon_afl_1 -m 200 -t 1000 -i seeds  -o level0  -- ./smbc 0