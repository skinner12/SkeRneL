#!/bin/sh

BASE=/home/tux/apps/nexus/
KERNEL=kernel/SkeRneL
ZIP=zipKernel
DATE=$(date +"%d%m%Y%H%M")



cd $BASE$KERNEL
git branch
read -p "Correct branch? [Y/N]: " -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
	    	echo -e "\n"
	        exit 1
        fi

echo -e "\nSTARTING...\n"

export PATH=$PATH:/home/tux/apps/nexus/toolchain/ZenKernel_ARCH_armv7a_compiler/bin/
#export PATH=$PATH:/home/tux/apps/nexus/toolchain/arm-2012.09/bin/
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=arm-zen-linux-gnueabi-
#export CROSS COMPILE=arm-none-eabi-

#cp arch/arm/configs/crespo_dave_config ./.config
make -j4

echo -e "Checking result...\n"
ls -l $BASE$KERNEL/arch/arm/boot/zImage

echo -e "Copying Files...\n"
cp $BASE$KERNEL/arch/arm/boot/zImage $BASE$KERNEL/mkboot/
cd $BASE$KERNEL/mkboot
./mkbootimg --kernel zImage --ramdisk cyan2disk_new.cpio.gz --cmdline 'no_console_suspend=1 console=bull's --base 0x30000000 --pagesize 4096 -o boot.img

echo -e "Creating ZIP...\n"
cp $BASE$KERNEL/mkboot/boot.img $BASE$ZIP/boot.img
cp $BASE$KERNEL/mkboot/zImage $BASE$ZIP/kernel/zImage
cp $BASE$KERNEL/drivers/scsi/scsi_wait_scan.ko $BASE$ZIP/system/modules/
7z a -r -tzip $BASE/SkeRneL-$DATE.zip $BASE$ZIP/*

#make clean

rm $BASE$ZIP/kernel/zImage
rm $BASE$KERNEL/mkboot/zImage
rm $BASE$KERNEL/mkboot/boot.img
rm $BASE$ZIP/boot.img
rm $BASE$ZIP/system/modules/scsi_wait_scan.ko
