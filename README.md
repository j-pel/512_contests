# 512_contests
512 bytes assembly contest own submission.
Use a VirtualBox machine with just a raw floppy disk image. Then copy the first 512 bytes to the raw image:
```
$ dd if=file.bin of=/dev/fd0
```
Or launch qemu:
```
$ qemu -fda floppy.flp
```
# LocOS
This attempt at a bootable fasm IDE with syntax highlighting for a 512 bytes contest held at the flat assembler board in 2004, finishing in third place. The code in this repository does not correspond to the final submitted version. I lost it, but found a previous incarnation.
- LocOS does not run properly on VirtualBox.
- LocOS runs on qemu but with some issues.
- LocOS runs properly on Bochs and on bare metal.

# NNew
This is an attempt prepared for the [20th anniversary of flat assembler](https://contest.flatassembler.net/) contest.
