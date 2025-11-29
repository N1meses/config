from fastmcp import FastMCP
from dotenv import load_dotenv
from typing import List, Dict
from pathlib import Path

import asyncio
import os

mcp = FastMCP("Filesystem Server")

AllowedPaths = [Path("/etc/nixos"), Path.home(), Path("/home/git")]

class PathValidator:
    @staticmethod
    def validate(ipath: str) -> Path:
        path = Path(ipath).expanduser().resolve()

        for allowed in AllowedPaths:
            allowed_resolved = allowed.resolve()
            if allowed_resolved == path or allowed_resolved in path.parents:
                return path

        raise ValueError(
            f"Access denied: {path} is outside allowed directories. "
            f"Allowed: {[str(d) for d in AllowedPaths]}"
        )


@mcp.tool()
def list_directory(path: str, recursive: bool = False) -> List[str]:
    """
    List all files and directories within a directory.

    Args:
        Path: Directory path to list
        recursive: If True, recursively list all subdirectories

    Returns:
        List of file and directory names (unsorted, as found on filesystem)
        For recursive listings, returns relative paths from the base directory.

    Raises:
        FileNotFoundError: If the directory doesn't exist
        ValueError: If path is not a directory or outside allowed directories
        PermissionError: If access to the directory is denied
    """
    validated_path = PathValidator.validate(path)

    if not validated_path.exists():
        raise FileNotFoundError(f"Directory not found: {path}")

    if not validated_path.is_dir():
        raise ValueError(f"Not a directory: {path}")

    items = []

    if recursive:
        #list recursivly
        for item in validated_path.rglob("*"):

            #ignore dotfiles
            if item.name.startswith("."):
                continue

            try:
                # Get path relative to the base directory
                relative_path = item.relative_to(validated_path)
                items.append(str(relative_path))
            except ValueError:
                # Skip if we can't get relative path
                continue

    else:
        for item in validated_path.iterdir():
            # Skip hidden files unless requested
            if item.name.startswith('.'):
                continue

            items.append(item.name)

    items.sort()

    return items

@mcp.tool()
def create_directory(path: str) -> str:
    """
    Create a new directory, including parent directories if needed.

    Args:
        path: Path to the directory to create

    Returns:
        Success message
    """
    validated_path = PathValidator.validate(path)

    # Create directory and all parent directories
    validated_path.mkdir(parents=True, exist_ok=True)

    return f"Created directory: {path}"

@mcp.tool()
def read_file(path: str) -> str:
    """
        Read the complete contents of a file.

        Args:
            path: Path to the file to read

        Returns:
            File contents as a string
        """
    validated_path = PathValidator.validate(path)

    if not validated_path.is_file():
        raise ValueError(f"Not a file: {path}")

    contents = validated_path.read_text(encoding='utf-8')

    return contents

@mcp.tool()
def find_in_directory(path: str, pattern: str, recursive: bool = True) -> list[str]:
    """
    Find files and directories matching a pattern.

    Args:
        path: Directory to search in
        pattern: Glob pattern to match (e.g., "*.py", "test*", "*.txt")
        recursive: If True, search recursively in subdirectories

    Returns:
        List of matching paths (relative to the search directory)
    """
    validated_path = PathValidator.validate(path)

    if not validated_path.is_dir():
        raise ValueError(f"Not a directory: {path}")

    matches = []

    if recursive:
        # Recursive search using rglob
        for item in validated_path.rglob(pattern):
            relative_path = item.relative_to(validated_path)
            matches.append(str(relative_path))
    else:
        # Non-recursive search using glob
        for item in validated_path.glob(pattern):
            matches.append(item.name)

    return matches


if "__name__" == "__main__":
    mcp.run(
        transport="http",
        host="0.0.0.0",
        port=8001,
    )