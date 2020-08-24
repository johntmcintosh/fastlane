#!/bin/zsh

_fastlane_complete() {
  local word completions
  word="$1"

  # look for Fastfile either in this directory or fastlane/ then grab the lane names
  if [[ -e "Fastfile" ]] then
    file="Fastfile"
  elif [[ -e "fastlane/Fastfile" ]] then
    file="fastlane/Fastfile"
  elif [[ -e ".fastlane/Fastfile" ]] then
    file=".fastlane/Fastfile"
  fi

  # parse 'beta' out of 'lane :beta do', etc
  completions=`cat $file | grep "^\s*lane \:" | awk -F ':' '{print $2}' | awk -F ' ' '{print $1}'`

  # look for any other Fastfiles that are imported from the current fastfile
  importedFiles=`cat $file | grep "^\s*import(\"" | awk -F '"' '{print $2}'`

  # add lane name imported fastfiles to available completions
  echo $importedFiles | while read fileImport; do
    importedFile="$(dirname "$file")/$fileImport"
    completions="$completions
`cat $importedFile | grep "^\s*lane \:" | awk -F ':' '{print $2}' | awk -F ' ' '{print $1}'`"
  done

  completions="$completions
update_fastlane"

  reply=( "${(ps:\n:)completions}" )
}

