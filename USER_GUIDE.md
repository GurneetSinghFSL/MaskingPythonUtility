# User Guide

## Quick Start

1. Put source Excel files in `Input`.
2. Update `Masking.xlsx` with file names and columns to be masked.
3. Verify `utility-config.json` values.
4. Run `Mask.bat` to mask.
5. Run `Unmask.bat` to unmask.

If Python is not in PATH, launcher tries common local Python/Conda locations automatically.
If runtime is still not found, it shows a Windows popup with guidance.

For distribution, use bundled build output (`release/`) so end users do not need Python installed.

## Important Behavior

- Only columns listed in `Masking.xlsx` for each file are changed.
- Files are processed from `Input` and written to:
  - `Output/Masked` (mask mode)
  - `Output/Unmasked` (unmask mode)
- If a file has no rule in `Masking.xlsx`, it is copied to output without data changes.

## GUI Mode (headless_run = false)

- A window appears with a green progress bar.
- Percentage increases as files are processed.
- On errors, an error popup shows failed files.
- At completion, a summary popup shows:
  - total file count
  - successful file count
  - failed file count
  - total cells affected
- If no input files are present, an info popup clearly states no files were found and shows the input folder path.

## Headless Mode (headless_run = true)

- No GUI windows are shown.
- Progress and summary are written via logs/console.
- If no input files are present, a clear no-files message is printed in console/log.

## Troubleshooting

- Check `Logs/masking_utility.log` for stack traces.
- Ensure file names in `Masking.xlsx` match exact input workbook names.
- Ensure pass phrase is identical for mask and unmask.

## Packaging For End Users

1. Run `build-release.bat` on a build machine.
2. Share the generated `release` folder as-is.
3. End users run `Mask.bat` / `Unmask.bat` directly from `release`.
