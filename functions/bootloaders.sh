#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2016 Adrian Gibanel Lopez <adrian15sgd@gmail.com>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.

Is_Primary_Bootloader ()
{
	EVAL_PRIMARY_BOOTLOADER="${1}"

	if [ "${LB_PRIMARY_BOOTLOADER}" = "${EVAL_PRIMARY_BOOTLOADER}" ] ; then
		return 0;
	else
		return 1;
	fi

}

Is_Bootloader ()
{
	EVAL_BOOTLOADER="${1}"

	OLDIFS="$IFS"
	IFS=","
	for BOOTLOADER in ${LB_BOOTLOADERS}
	do
		case ${BOOTLOADER} in
			"${EVAL_BOOTLOADER}" )
                return 0;
       esac
	done
	return 1;
}

Is_Secondary_Bootloader ()
{
	EVAL_SECONDARY_BOOTLOADER="${1}"
	if ! Is_Primary_Bootloader "${EVAL_SECONDARY_BOOTLOADER}" ; then
		if Is_Bootloader	"${EVAL_SECONDARY_BOOTLOADER}" ; then
			return 0;
		fi
	fi
	return 1;

}

