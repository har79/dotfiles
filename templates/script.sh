#!/bin/bash

## internal variables
_SCRIPT_NAME="${0##*/}"
_VERBOSE=""

## internal functions

# _checkArg $arg $accepted
#     $accepted is a `|' or ` ' separated list of the accepted values of $arg
#     return: 0 if $arg matches a value in $accepted; 1 otherwise
_checkArg () {
    accepted="${2//\|/ }"
    for i in $accepted; do
   	 if [ "$1" == $i ]; then
   		 return 0
   	 fi
    done
    return 1
}

# _err $message
#     prints $message to stderr and exits the program with status 1
_err () {
    echo "$_SCRIPT_NAME: $1" >&2
    exit 1
}

# _log $message
#     prints $message to stderr if logging has been enabled by the `-v' option
_log () {
    if [ -n "$_VERBOSE" ]; then
   	 echo "$_SCRIPT_NAME: $1" >&2
    fi
}

# _logVar $varName
#    prints the name and value of $varName to stderr if logging has been enabled (see _log)
_logVar () {
    _log "$1=${!1}"
}

# _printUsage [$full]
#     prints the usage message to stderr; if $full is set, option descriptions will also be printed
_printUsage () {
    cat >&2 <<EOF
usage: $_SCRIPT_NAME [-hv]
EOF
    if [ -n "$1" ]; then
   	 cat >&2 <<EOF

  -h    Show this help
  -v    Print debugging messages
EOF
    fi
}

## global variables

## options parsing
while getopts ":hv" option; do
    case "$option" in
    "h")
   	 _printUsage 1
   	 exit 0
   	 ;;
    "v")
   	 _VERBOSE=1
   	 ;;
    ":")
   	 _err "option \`$OPTARG' requires an argument"
   	 ;;
    "?")
   	 _err "invalid option -- \`$OPTARG'"
   	 ;;
    *)
   	 _err "invalid option -- \`$option'"
   	 ;;
    esac
done
shift $((OPTIND - 1))

## argument parsing
if (( $# == 0 )); then
    :
else
    _printUsage
    exit 1
fi

## functions

## main

