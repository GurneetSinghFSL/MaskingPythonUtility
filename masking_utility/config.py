from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path

DEFAULT_PASSPHRASE = "Qp7$Nw3!rT9@xV2#Lm8^kD5&zY1*Hs6%Jc4!"


@dataclass(frozen=True)
class AppConfig:
    input_folder: Path
    output_folder_masked: Path
    output_folder_unmasked: Path
    log_folder: Path
    masking_rules_file: Path
    pass_phrase: str
    headless_run: bool



def _resolve(base: Path, value: str) -> Path:
    path = Path(value)
    return path if path.is_absolute() else (base / path).resolve()


def _parse_bool(value: object, default: bool = False) -> bool:
    if isinstance(value, bool):
        return value
    if value is None:
        return default
    if isinstance(value, (int, float)):
        return bool(value)
    if isinstance(value, str):
        normalized = value.strip().lower()
        if normalized in {"true", "1", "yes", "y", "on"}:
            return True
        if normalized in {"false", "0", "no", "n", "off", ""}:
            return False
    return default



def load_config(config_file: Path) -> AppConfig:
    with config_file.open("r", encoding="utf-8") as fh:
        raw = json.load(fh)

    base = config_file.parent.resolve()

    input_folder = _resolve(base, raw.get("input_folder", "Input"))
    output_root = _resolve(base, raw.get("output_folder", "Output"))
    output_folder_masked = _resolve(base, raw.get("output_folder_masked", str(output_root / "Masked")))
    output_folder_unmasked = _resolve(base, raw.get("output_folder_unmasked", str(output_root / "Unmasked")))
    log_folder = _resolve(base, raw.get("log_folder", "Logs"))
    masking_rules_file = _resolve(base, raw.get("masking_rules_file", "Masking.xlsx"))

    pass_phrase = raw.get("pass_phrase", DEFAULT_PASSPHRASE)
    headless_run = _parse_bool(raw.get("headless_run", False), default=False)

    return AppConfig(
        input_folder=input_folder,
        output_folder_masked=output_folder_masked,
        output_folder_unmasked=output_folder_unmasked,
        log_folder=log_folder,
        masking_rules_file=masking_rules_file,
        pass_phrase=pass_phrase,
        headless_run=headless_run,
    )
