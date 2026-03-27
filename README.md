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

## Setup

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

Or run manually:

```bash
python -m masking_utility.cli mask --config utility-config.json
python -m masking_utility.cli unmask --config utility-config.json
```

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
