from __future__ import annotations

import tkinter as tk
from tkinter import messagebox, ttk


class ProgressUI:
    def __init__(self, mode: str, total_files: int) -> None:
        self.total_files = max(total_files, 1)
        self.root = tk.Tk()
        self.root.title(f"{mode.title()} Progress")
        self.root.geometry("520x140")
        self.root.resizable(False, False)

        self.status_text = tk.StringVar(value="Starting...")
        self.percent_text = tk.StringVar(value="0%")

        frame = ttk.Frame(self.root, padding=12)
        frame.pack(fill="both", expand=True)

        ttk.Label(frame, textvariable=self.status_text, wraplength=490).pack(anchor="w", pady=(0, 8))

        style = ttk.Style(self.root)
        style.theme_use("default")
        style.configure(
            "Green.Horizontal.TProgressbar",
            troughcolor="#d9d9d9",
            background="#2aa745",
            darkcolor="#2aa745",
            lightcolor="#2aa745",
            bordercolor="#d9d9d9",
        )

        self.bar = ttk.Progressbar(
            frame,
            style="Green.Horizontal.TProgressbar",
            orient="horizontal",
            mode="determinate",
            maximum=100,
            length=490,
        )
        self.bar.pack(anchor="w")

        ttk.Label(frame, textvariable=self.percent_text).pack(anchor="e", pady=(6, 0))

        self.root.update_idletasks()
        self.root.update()

    def update(self, processed_files: int, current_file: str) -> None:
        percent = int((processed_files / self.total_files) * 100)
        self.status_text.set(f"Processing {processed_files}/{self.total_files}: {current_file}")
        self.percent_text.set(f"{percent}%")
        self.bar["value"] = percent
        self.root.update_idletasks()
        self.root.update()

    def close(self) -> None:
        self.root.destroy()



def show_error_popup(title: str, message: str) -> None:
    root = tk.Tk()
    root.withdraw()
    messagebox.showerror(title=title, message=message)
    root.destroy()



def show_info_popup(title: str, message: str) -> None:
    root = tk.Tk()
    root.withdraw()
    messagebox.showinfo(title=title, message=message)
    root.destroy()
