# rpajarola's Homebrew tap

```
brew install rpajarola/tap/gobootd   # boot server for old and unusual machines
brew install rpajarola/tap/tme-rp    # The Machine Emulator (Sun-2, Sun-3, Sun-4c, UltraSPARC)
brew install rpajarola/tap/gxemul-rp # GXemul, with SIMH tapes, TURBOchannel ROMs and L2TPv3
brew install rpajarola/tap/mirrortools # mirror HTTP, FTP, archive.org, IMAP, ... to disk
```

Add `--HEAD` to build from the main branch.

`tme-rp` and `gxemul-rp` were called `tme` and `gxemul` before 1.0.0;
`brew upgrade` moves existing installs to the new names
([`formula_renames.json`](formula_renames.json)).

The formulas are updated by the release workflows of
[gobootd](https://github.com/rpajarola/gobootd),
[tme](https://github.com/rpajarola/tme),
[gxemul](https://github.com/rpajarola/gxemul) and
[mirrortools](https://github.com/rpajarola/mirrortools): publishing a release there
points the formula at the release's source tarball.
