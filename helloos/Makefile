
# デフォルト動作

default :
	../tolset/z_tools/make.exe img

# ipl.bin 512个字?的引?扇区

ipl.bin : ipl.nas Makefile
	../tolset/z_tools/nask.exe ipl.nas ipl.bin ipl.lst

#  helloos.img是1024个字?，?里加入了其他内容
helloos.img : ipl.bin Makefile
	../tolset/z_tools/edimg.exe   imgin:../tolset/z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0   imgout:helloos.img

# コマンド

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
