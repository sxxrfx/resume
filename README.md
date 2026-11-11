<img src="assets/icon.svg" width="64" height="64" alt="">

# Resume

Sagar Negi's resume: **[sxxrfx.github.io/resume](https://sxxrfx.github.io/resume/)** · [PDF](https://sxxrfx.github.io/resume/Sagar-Negi-Resume.pdf)

The resume is one static page, `index.html` with `style.css`. There is no build step for the page. It follows the system light or dark theme, has a toggle, and its print styles fit one A4 page.

The PDF is not stored in the repository. On every push to `main`, [the Pages workflow](.github/workflows/pages.yml) prints `index.html` to `Sagar-Negi-Resume.pdf` with headless Chrome and deploys both, so the PDF always matches the page. The workflow fails if the PDF is not exactly one page.

## Edit

Change the text in `index.html` and push. Sections that still need details are marked `TODO(Sagar)` in comments there.

To preview, open `index.html` in a browser. To build the PDF locally, with any Chromium-based browser:

```sh
scripts/build-pdf.sh
BROWSER="/Applications/Helium.app/Contents/MacOS/Helium" scripts/build-pdf.sh   # or name the browser
```

## Fonts

[Inter](https://github.com/rsms/inter) and [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) are bundled in `fonts/` under the SIL Open Font License; the license texts are next to them.
