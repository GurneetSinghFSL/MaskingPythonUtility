from __future__ import annotations

import argparse
import sys
import traceback
from pathlib import Path

from .config import load_config
from .logging_utils import setup_logger
from .processor import WorkbookProcessor
from .ui import ProgressUI, show_error_popup, show_info_popup


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Masking and Unmasking Utility")
    parser.add_argument("mode", choices=["mask", "unmask"], help="Operation mode")
    parser.add_argument(
        "--config",
        default="utility-config.json",
        help="Path of configuration file",
    )
    return parser



def main() -> int:
    parser = _build_parser()
    args = parser.parse_args()

    config = load_config(Path(args.config).resolve())
    logger = setup_logger(config.log_folder)

    logger.info("main start | mode=%s | config=%s", args.mode, args.config)

    ui = None
    try:
        processor = WorkbookProcessor(config=config, logger=logger)

        total_files = len(list(config.input_folder.glob("*.xlsx")))
        if total_files == 0:
            no_files_message = (
                f"Operation: {args.mode}\n"
                f"No .xlsx files found in input folder:\n{config.input_folder}\n\n"
                "Place files in the input folder and run again."
            )
            logger.warning(
                "no input files found | mode=%s | input_folder=%s",
                args.mode,
                config.input_folder,
            )
            if not config.headless_run:
                show_info_popup("No Input Files", no_files_message)
            else:
                print(no_files_message)
            logger.info("main end | no input files")
            return 0

        if not config.headless_run:
            ui = ProgressUI(mode=args.mode, total_files=total_files)

        summary = processor.run(
            mode=args.mode,
            progress_callback=(ui.update if ui else None),
        )

        summary_message = (
            f"Operation: {args.mode}\n"
            f"Total files: {summary.total_files}\n"
            f"Successful files: {summary.success_files}\n"
            f"Failed files: {summary.failed_files}\n"
            f"Total cells affected: {summary.total_cells_affected}"
        )

        if summary.errors:
            logger.error("run completed with errors | errors=%s", summary.errors)
            if not config.headless_run:
                show_error_popup("Processing Errors", "\n".join(summary.errors[:10]))

        if not config.headless_run:
            show_info_popup("Processing Summary", summary_message)
        else:
            print(summary_message)

        logger.info("main end | success")
        return 0 if summary.failed_files == 0 else 2
    except Exception as exc:
        logger.exception("main failed")
        msg = f"{exc}\n\n{traceback.format_exc()}"
        if 'config' in locals() and not config.headless_run:
            show_error_popup("Fatal Error", msg)
        else:
            print(msg, file=sys.stderr)
        return 1
    finally:
        if ui:
            ui.close()


if __name__ == "__main__":
    raise SystemExit(main())
