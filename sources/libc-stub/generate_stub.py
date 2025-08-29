#!/usr/bin/env python3

import argparse

from pathlib import Path

from typing import List, Set


def generate_stub(input_files: List[Path | str], output_file: Path | str) -> None:
    input_files, output_file = [Path(file) for file in input_files], Path(output_file)

    symbols: Set[str] = set()
    for input_file in input_files:
        with open(input_file, "r") as f:
            file_symbols: List[str] = f.readlines()
        for symbol in file_symbols:
            if symbol in symbols:
                print(f"WARN: Duplicate symbol ({symbol.strip()}) found in {input_file}.")
            symbols.add(symbol)

    stub_functions: List[str] = [
        f"void {symbol[1:].strip()}() {{}}\n" for symbol in symbols
    ]
    stub_functions.sort()

    with open(output_file, "w", encoding="utf-8") as f:
        f.writelines(stub_functions)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert a list of symbols to a stub c file"
    )
    parser.add_argument(
        "symbol_lists",
        help="A list of symbols to use to generate a stub c file",
        type=Path,
        nargs="+",
    )
    parser.add_argument("output", help="Output file name.", type=Path)
    args = parser.parse_args()
    generate_stub(args.symbol_lists, args.output)


if __name__ == "__main__":
    main()
