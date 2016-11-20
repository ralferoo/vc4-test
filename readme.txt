This is just an initial test of the VC4 toolchain, based on what I found
here:
	https://github.com/hermanhermitage/videocoreiv/wiki/VideoCore-IV-Kernels-under-Linux

alpha.bin comes from https://dl.dropbox.com/u/3669512/temp/alpha.bin

The disassembly of the original mostly proceeds well, except that the 65535
constant is too big for the assembler to accept, although it's OK with -1.

The opcodes are very different from the original (see alpha.txt)

BUG: the disassembly looks similar to the original, but the opcodes are
slightly different (see alpha.txt). However, feeding them back into gas
produces a disassembly that's wrong. See diff.txt but the codegen differences
seem to be mostly in the v16ld and v16st instructions, e.g. f940 instead of f850:

10,15c10,17
<    6:	0b f8 38 84 80 03 	v16ld HX(16++,0),(r2+=r5) REP8
<    c:	40 f9 08 00 
<   10:	0b f8 38 88 80 03 	v16ld HX(32++,0),(r3+=r5) REP8
<   16:	40 f9 0c 00 
<   1a:	0b f8 38 80 80 03 	v16ld HX(0++,0),(r1+=r5) REP8
<   20:	40 f9 04 00 
---
> 
> 00000006 <loop>:
>    6:	0b f8 38 84 80 03 	v16ld HX(16++,0),(r2[ra/d low bits 1?]+=r1) REP8
>    c:	50 f8 08 00 
>   10:	0b f8 38 88 80 03 	v16ld HX(32++,0),(r3[ra/d low bits 1?]+=r1) REP8
>   16:	50 f8 0c 00 
>   1a:	0b f8 38 80 80 03 	v16ld HX(0++,0),(r1[ra/d low bits 1?]+=r1) REP8
>   20:	50 f8 04 00 
28,29c30,31
<   60:	8b f8 20 e0 80 03 	v16st HX(0++,0),(r0+=r5) REP8
<   66:	e0 53 00 00 
---
>   60:	8b f8 20 e0 80 03 	v16st HX(0++,0),(r0[ra/d low bits 1?]+=r1) REP8
>   66:	e0 17 00 00 
