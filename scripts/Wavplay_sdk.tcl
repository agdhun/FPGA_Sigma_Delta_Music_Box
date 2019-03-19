setws .
# ����hardware 
createhw -name hw0 -hwspec ../wavtran_wrapper.hdf
# �½�FSBL
createapp -name fsbl -app {Zynq FSBL} -proc ps7_cortexa9_0 -hwproject hw0 -os standalone
# ���Debug macros
configapp -app fsbl define-compiler-symbols FSBL_DEBUG_DETAILED
# ����FatFs��
setlib -bsp fsbl_bsp -lib xilffs
# update
updatemss -mss fsbl_bsp/system.mss
# �ر���bsp
regenbsp -bsp fsbl_bsp

# �½�Project
createapp -name wavdatatran -app {Hello World} -bsp fsbl_bsp -proc ps7_cortexa9_0 -hwproject hw0 -os standalone
# ����uart
#configbsp -bsp wavdatatran_bsp stdin ps_uart_1
#configbsp -bsp wavdatatran_bsp stdout ps_uart_1
#  
configapp -app wavdatatran -add compiler-misc {-std=c99}

file copy -force ../source/sdk/wavtran.c wavdatatran/src/
file delete wavdatatran/src/helloworld.c
#sdk setws -switch $ :: env(TEMP)
#exec $eclipse -vm $vm -nosplash                                    \
#    -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
#    -import "file://$apppath" -data $wspath
#	
#sdk setws -switch $ :: env(TEMP)

projects -build


# exec bootgen -arch zynq -image output.bif -w -o BOOT.bin
# exec program_flash -f /tmp/wrk/BOOT.bin -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url tcp:localhost:3121