#!/Users/stuartadamson/.pyenv/shims/python
import os
import sys
import fnmatch

from ninja_syntax import Writer

prod="test"

with open("build.ninja", "w") as buildfile:

    n = Writer(buildfile)

    n.rule("m4", command="m4 $in > $out", description="m4 $out")
    n.newline()

    n.rule("z80asm", command="z80asm -O../build $in", description="z80asm $out")
    n.newline()

    n.rule("asmlink", command="z80asm +zx81 -b $in", description="asmlink $out")
    n.newline()

    asmFiles = []
    for root, dirnames, filenames in os.walk("."):
        for filename in fnmatch.filter(filenames, "*.asm"):
            asmFiles.append(filename)

    for root, dirnames, filenames in os.walk("."):
        for filename in fnmatch.filter(filenames, "*.m4"):
            outfile = os.path.join("..", "build", os.path.splitext(filename)[0])
            n.build(outfile, "m4", filename)
            asmFiles.append(outfile)

    n.newline()

    oFiles = []
    for asmFile in asmFiles:
        outfile =  os.path.splitext(asmFile)[0] + ".o"

        if "build" in asmFile:
            n.build(outfile, "z80asm", asmFile)
            oFiles.append(outfile)
        else:
            outPath = os.path.join("..", "build", outfile)
            n.build(outPath, "z80asm", asmFile)
            oFiles.append(outPath)

    prodfile = ""
    oFileSize = len(oFiles)
    for oFile in oFiles:
        if prod + ".o" in oFile:
            prodfile = oFile
            oFiles.remove(oFile)
            break
    
    
    
    n.newline()

    oFileList = " "
    oFileList.join(oFiles)

    buildfile.write("build ../build/test.bin ../build/test.P: ")
    buildfile.write("asmlink ")

    if (oFileSize != len(oFiles)):
        buildfile.write(prodfile + " ")

    for oFile in oFiles:
        buildfile.write(oFile + " ")

    #n.build("../build/test.bin\ ../build/test.P", "z80asmlink", oFiles)

    n.newline()
