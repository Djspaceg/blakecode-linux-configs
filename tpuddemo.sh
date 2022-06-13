#!/usr/bin/env zsh
# tputdemo.sh

echo -e "\n$(tput bold) reg  dim  bld  und   tput-command$(tput sgr0)"
for i in $(seq 0 7); do
  for k in sgr0 dim bold smul; do
    echo -n " $(tput $k)$(tput setaf $i)Text$(tput sgr0)"
  done
  echo    "  \$(tput setaf $i)"
done

echo
echo ' Dim        $(tput dim)'
echo ' Bold       $(tput bold)'
echo ' Underline  $(tput smul)'
echo ' Reset      $(tput sgr0)'

echo -e "\n$(tput bold) bg   blk  wht  brwht   tput-command$(tput sgr0)"
for i in $(seq 0 7); do
  echo -n "$(tput setab $i) Text $(tput sgr0)"
  echo -n "$(tput setab $i)$(tput setaf 0)Text $(tput sgr0)"
  echo -n "$(tput setab $i)$(tput setaf 7)Text $(tput sgr0)"
  echo -n "$(tput setab $i)$(tput setaf 15)Text $(tput sgr0)"
  echo    "  \$(tput setab $i)"
done

echo