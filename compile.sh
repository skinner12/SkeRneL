#!/bin/bash

BASE=/home/tux/nexus/
KERNEL=kernel/SkeRneL
ZIP=zipKernel
TOOLCHAIN=toolchain
DATE=$(date +"%d%m%Y%H%M")

#COLORI

grassetto=$(tput bold)
sottolineato=$(tput sgr 0 1)
rosso=$(tput setaf 1)
blu=$(tput setaf 4)
bianco=$(tput setaf 7)
reset=$(tput sgr0)
info=$bianco*${txtrst}        # Feedback
pass=$blu*${txtrst}
warn=$rosso*${txtrst}
ques=$blu?${txtrst}


cd $BASE$KERNEL

function usage ()
{
       echo -e "$info Usage: (order of parameters are important !)"
       echo -e "        compile.sh [--compile|--zip] "
       echo -e "\n--compile (-c) : Compile the kernel."
              echo -e "\n--clean (-cl) : Clean the kernel."
       echo -e "\n--zip (-z) : Create a flashable zip file.\n $reset"
}

function makeKernel ()
{

git branch
read -p "$warn Correct branch? [Y/N]: $reset" -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
	    	echo -e "\n"
	        exit 1
        fi

echo -e "$pass \nSTARTING...\n $reset"

export PATH=$BASE$TOOLCHAIN/gcc-linaro-arm-linux-gnueabihf-4.7-2013.01-20130125_linux/bin:$PATH

export ARCH=arm
export SUBARCH=arm

export CROSS COMPILE=arm-linux-gnueabihf-

exec "$@"

#cp arch/arm/configs/crespo_dave_config ./.config


rm .version
echo "45" >> .version
make -j4

echo -e "$warn \nChecking result...\n"
ls -l $BASE$KERNEL/arch/arm/boot/zImage
echo -e "$reset"

}


function makeZip ()
{

echo -e "$info Copying Files...\n $reset"

echo -e "$(tput bold) Copying $BASE$KERNEL/drivers/scsi/scsi_wait_scan.ko...\n$(tput sgr0)"
cp $BASE$KERNEL/drivers/scsi/scsi_wait_scan.ko $BASE$ZIP/system/modules/

echo -e "$(tput bold) Copying $BASE$KERNEL/arch/arm/boot/zImage...\n$(tput sgr0)"
cp $BASE$KERNEL/arch/arm/boot/zImage $BASE$ZIP/kernel/zImage

echo -e "$info Creating ZIP...\n $reset"

7za a -r -tzip $BASE/SkeRneL-$DATE.zip $BASE$ZIP/*


#make clean

rm $BASE$ZIP/kernel/zImage
rm $BASE$ZIP/system/modules/scsi_wait_scan.ko


echo -e "\n $(tput bold)$pass"	ls -l $BASE/SkeRneL-$DATE.zip echo -e "$(tput sgr0)"


}


function makeClean ()
{

echo -e "$warn Cleanin compiled...\n $reset"

export PATH=$BASE$TOOLCHAIN/gcc-linaro-arm-linux-gnueabihf-4.7-2013.01-20130125_linux/bin:$PATH

export ARCH=arm
export SUBARCH=arm

export CROSS COMPILE=arm-linux-gnueabihf-

exec "$@"

#cp arch/arm/configs/crespo_dave_config ./.config

make clean

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
		       --clean|-cl)
				makeClean;

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
