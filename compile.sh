#!/bin/bash

BASE=/home/tux/nexus/
KERNEL=kernel/SkeRneL
ZIP=zipKernel
TOOLCHAIN=toolchain
DATE=$(date +"%d%m%Y%H%M")

cd $BASE$KERNEL

function usage ()
{
       echo -e "Usage: (order of parameters are important !)"
       echo -e "        myprog.sh [--compile|--zip] "
       echo -e "\n--compile (-c) : Compile the kernel."
       echo -e "\n--zip (-z) : Create a flashable zip file.\n"
}

function makeKernel ()
{

git branch
read -p "Correct branch? [Y/N]: " -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
	    	echo -e "\n"
	        exit 1
        fi

echo -e "\nSTARTING...\n"

export PATH=$BASE$TOOLCHAIN/gcc-linaro-arm-linux-gnueabihf-4.7-2013.01-20130125_linux/bin:$PATH

export ARCH=arm
export SUBARCH=arm

export CROSS COMPILE=arm-linux-gnueabihf-

exec "$@"

#cp arch/arm/configs/crespo_dave_config ./.config
make -j4

echo -e "Checking result...\n"
ls -l $BASE$KERNEL/arch/arm/boot/zImage

}


function makeZip ()
{

echo -e "Copying Files...\n"
cp $BASE$KERNEL/drivers/scsi/scsi_wait_scan.ko $BASE$ZIP/system/modules/


echo -e "Creating ZIP...\n"

7za a -r -tzip $BASE/SkeRneL-$DATE.zip $BASE$ZIP/*


	ls -l $BASE/SkeRneL-$DATE.zip


}


# Opzioni di scelta

if test "$1" == "" ; then
	usage;
else
	while test "$1" != "" ; do
		case $1 in

		        --compile|-c)
				makeKernel;

	 		;;
		        --zip|-z)
				makeZip;

		        ;;
		        --help|-h)
		                usage;
		               exit 0

		        ;;
		        -*)
		                echo "Error: no such option $1"
		                usage
		                exit 1
		        ;;
		esac
		echo -e ""
		shift

	done
fi
exit 0
