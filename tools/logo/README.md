# gsDesign hex sticker

From the package root, run:

```console
sh tools/logo/logo.sh
```

Requires Chrome, ImageMagick, Ghostscript, `pdfcrop`, and `pngquant`.
The SVG wordmark embeds its font data directly so logo generation does not
depend on remote assets or separate local font files.
By default the script looks for Chrome at
`/Applications/Google Chrome.app/Contents/MacOS/Google Chrome` on macOS,
`/c/Program Files/Google/Chrome/Application/chrome.exe` on Git Bash/MSYS/Cygwin/Win32,
and `/usr/bin/google-chrome` on Linux. Set `CHROME_BIN` to override the path.
