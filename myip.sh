#!/bin/bash
ifconfig | grep 'inet ' | tail -1 | awk '{print $2}'