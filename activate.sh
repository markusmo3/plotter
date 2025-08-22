#!/usr/bin/env bash
# used to initialize the venv
VENV_DIR=".venv"
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip install -r requirements.txt
else
    echo "Using existing virtual environment..."
    source "$VENV_DIR/bin/activate"
fi
