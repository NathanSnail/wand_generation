#!/bin/bash

stylua -c $(find . -type f -name \*.lua)
if rg 'require\(".*"\)'; then
	exit 1
else
	exit 0
fi
