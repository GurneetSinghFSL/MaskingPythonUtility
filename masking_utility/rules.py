from __future__ import annotations

from collections import defaultdict
from pathlib import Path
from typing import Dict, Set

from openpyxl import load_workbook


FILE_HEADER_CANDIDATES = {"file", "filename", "file_name", "excel", "excel_file", "workbook"}
COLUMN_HEADER_CANDIDATES = {"columns", "column", "column_name", "column_names", "mask_columns"}



def _normalize_header(header: str) -> str:
    return str(header).strip().lower().replace(" ", "_")



def load_rules(mapping_file: Path) -> Dict[str, Set[str]]:
    workbook = load_workbook(mapping_file, data_only=True)
    sheet = workbook.active

    headers = {}
    for index, cell in enumerate(sheet[1], start=1):
        if cell.value is None:
            continue
        headers[_normalize_header(str(cell.value))] = index

    file_col = next((headers[h] for h in headers if h in FILE_HEADER_CANDIDATES), None)
    columns_col = next((headers[h] for h in headers if h in COLUMN_HEADER_CANDIDATES), None)

    if not file_col or not columns_col:
        raise ValueError(
            "Masking.xlsx must contain file and columns headers. Supported examples: file_name, columns"
        )

    rules: Dict[str, Set[str]] = defaultdict(set)
    for row in range(2, sheet.max_row + 1):
        file_name = sheet.cell(row=row, column=file_col).value
        column_value = sheet.cell(row=row, column=columns_col).value

        if file_name is None or column_value is None:
            continue

        target_file = str(file_name).strip().lower()
        for col_name in str(column_value).split(","):
            cleaned = col_name.strip()
            if cleaned:
                rules[target_file].add(cleaned)

    return dict(rules)
