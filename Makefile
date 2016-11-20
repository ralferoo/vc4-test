all: alpha.txt test.txt diff.cat

.PRECIOUS: %.o %.txt

%.o: %.bin Makefile
	vc4-elf-objcopy -I binary $< -O elf32-vc4 -B vc4 --rename-section .data=.text,alloc,load,readonly,code,contents $@

%.o: %.s
	vc4-elf-as -o $@ $<

%.txt: %.o
	vc4-elf-objdump -d $< >$@

%.cat: %.txt
	cat $<

test.s: alpha.txt
	cut -c25- $< |sed -e '1,/bin_start/d;/^\s*$$/d;s/65535/-1/;s/6 ._binar.*$$/loop/;/v16ld.*16/s/^/loop:/;1,1s/^/.text\n.globl _binary_alpha_bin_start\n.align 2\n_binary_alpha_bin_start:\n/;/rts/q' >$@

diff.txt: alpha.txt test.txt
	diff $+ >$@ || true
