#!/usr/bin/env python3

import argparse

from pathlib import Path

from typing import List

def generate_stub(input_file: Path | str, output_file: Path | str) -> None:
    input_file, output_file = Path(input_file), Path(output_file)

    with open(input_file, "r") as f:
        symbols: List[str] = f.readlines()

    symbols = [f"void {symbol[1:].strip()}() {{}}\n" for symbol in symbols]

    with open(output_file, "w", encoding="utf-8") as f:
        f.writelines(symbols)

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert a list of symbols to a stub c file"
    )
    parser.add_argument(
        "symbol_list",
        help="A list of symbols to use to generate a stub c file",
        type=Path
    )
    parser.add_argument(
        "output",
        help="Output file name.",
        type=Path
    )
    args = parser.parse_args()
    generate_stub(args.symbol_list, args.output)

if __name__ == "__main__":
    main()