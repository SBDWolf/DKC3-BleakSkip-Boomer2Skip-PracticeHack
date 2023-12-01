del /q output
xcopy target output
asar.exe -Drom_revision=0 --fix-checksum=off src/main.asm output/DKC3USA.smc
asar.exe -Drom_revision=2 --no-title-check --fix-checksum=off src/main.asm output/DKC3J11.sfc