all: alpha.dis test.dis diff.txt

.PRECIOUS: %.o %.dis

%.o: %.bin Makefile
	vc4-elf-objcopy -I binary $< -O elf32-vc4 -B vc4 --rename-section .data=.text,alloc,load,readonly,code,contents $@

%.o: %.s
	vc4-elf-as -o $@ $<

%.dis: %.o
	vc4-elf-objdump -d $< >$@

%.cat: %.dis
	cat $<

test.s: alpha.dis
	cut -c25- $< |sed -e '1,/bin_start/d;/^\s*$$/d;s/65535/-1/;s/6 ._binar.*$$/loop/;/v16ld.*16/s/^/loop:/;1,1s/^/.text\n.globl _binary_alpha_bin_start\n.align 2\n_binary_alpha_bin_start:\n/;/rts/q' >$@

diff.txt: alpha.dis test.dis
	diff $+

