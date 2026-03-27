# MaskingPythonUtility

Python utility to mask and unmask selected Excel columns based on rules defined in `Masking.xlsx`.

## Features

- Reversible masking and unmasking using pass phrase based encryption.
- File/column specific processing driven by `Masking.xlsx`.
- Detailed logging for method start/end, checkpoints, exceptions, and stack traces.
- GUI mode (`headless_run = false`) with:
  - Green progress bar with percentage updates.
  - Error popup when file-level or fatal errors occur.
  - Final summary popup.
  - Clear info popup when no input files are found.
- Headless mode (`headless_run = true`) for silent/scripted runs.

## Folder Structure

Expected distribution structure:

- `Logs/`
- `Input/`
- `Output/Masked/`
- `Output/Unmasked/`
- `Masking.xlsx`
- `utility-config.json`
- `Mask.bat`
- `Unmask.bat`

## Setup (Development)

1. Install Python 3.10+.
2. Install dependencies:

```bash
pip install -r requirements.txt
```

## Configuration

Edit `utility-config.json`:

- `input_folder`: source Excel files to process.
- `output_folder_masked`: destination for masked files.
- `output_folder_unmasked`: destination for unmasked files.
- `log_folder`: folder for rotating logs.
- `masking_rules_file`: masking rules workbook path.
- `pass_phrase`: pass phrase used for mask/unmask.
- `headless_run`: `false` for GUI popups and progress bar, `true` for console/headless mode.
  - Supported values: boolean (`true`/`false`) or text equivalents (`"true"`, `"false"`, `"yes"`, `"no"`, `"1"`, `"0"`).

Default pass phrase:

`Qp7$Nw3!rT9@xV2#Lm8^kD5&zY1*Hs6%Jc4!`

## Masking Rules File (`Masking.xlsx`)

The first sheet must contain headers equivalent to:

- File column: one of `file`, `filename`, `file_name`, `excel`, `excel_file`, `workbook`
- Columns column: one of `columns`, `column`, `column_name`, `column_names`, `mask_columns`

Each row links a workbook name to one or more comma-separated columns.

Example:

| file_name     | columns         |
|---------------|-----------------|
| Customer.xlsx | Email, MobileNo |
| Orders.xlsx   | CardNumber      |

## Run

Double-click:

- `Mask.bat` for masking
- `Unmask.bat` for unmasking

Batch launcher behavior:

- Prefers bundled runtime executable at `bin/MaskingUtility.exe` when available.
- Detects Python using `py -3` or `python` from PATH.
- Falls back to common local installations such as `%LOCALAPPDATA%\\anaconda3\\python.exe`.
- If no runtime is found, shows a Windows error popup instead of silently closing.

Or run manually:

```bash
python -m masking_utility.cli mask --config utility-config.json
python -m masking_utility.cli unmask --config utility-config.json
```

## Build No-Install Runtime (For End Users)

Create a bundled Windows executable with Python runtime included:

```bat
build-release.bat
```

Build script behavior:

- Creates and uses an isolated build environment at `.build-venv`.
- Installs only required packages plus PyInstaller for packaging.
- Avoids scanning heavy global Conda packages that can make builds look stuck.
- First run may take several minutes.

Build output is created in `release/` with this structure:

- `release/bin/MaskingUtility.exe`
- `release/Input/`
- `release/Logs/`
- `release/Output/Masked/`
- `release/Output/Unmasked/`
- `release/Masking.xlsx`
- `release/utility-config.json`
- `release/Mask.bat`
- `release/Unmask.bat`

End users can run `Mask.bat` / `Unmask.bat` from `release/` without installing Python.

## Logs

Logs are written to:

- `Logs/masking_utility.log`

The logs include:

- method start/end
- key processing checkpoints
- exception messages
- full stack traces for failures

## No Input Files Behavior

- If no `.xlsx` files are found in `input_folder`, utility exits gracefully.
- GUI mode: shows a final info popup with the input folder path.
- Headless mode: prints the same message in console/logs.
