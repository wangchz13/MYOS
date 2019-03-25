
# 默认规则

default :
	../tolset/z_tools/make.exe img

# ipl.bin 512字节的启动扇区

ipl.bin : ipl.nas Makefile
	../tolset/z_tools/nask.exe ipl.nas ipl.bin ipl.lst

#  helloos.img 大小为1024字节
helloos.img : ipl.bin Makefile
	../tolset/z_tools/edimg.exe   imgin:../tolset/z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0   imgout:helloos.img

# 其他

asm :
	../tolset/z_tools/make.exe -r ipl.bin

img :
	../tolset/z_tools/make.exe -r helloos.img

run :
	../tolset/z_tools/make.exe img
	copy helloos.img ..\tolset\z_tools\qemu\fdimage0.bin
	../tolset/z_tools/make.exe -C ../tolset/z_tools/qemu

install :
	../tolset/z_tools/make.exe img
	../tolset/z_tools/imgtol.com w a: helloos.img

clean :
	-del ipl.bin
	-del ipl.lst

src_only :
	../tolset/z_tools/make.exe clean
	-del helloos.img
