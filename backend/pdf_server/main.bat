@echo off

set PYTHON_EXE=python
set VENV_NAME=venv

if not exist %VENV_NAME% (
	echo Creating virtual environment...
	%PYTHON_EXE% -m venv %VENV_NAME%
)
call %VENV_NAME%\Scripts\activate
echo Installing dependencies...

echo .
echo .
echo .
echo Check updates at https://github.com/sdmdg/vaultapp :)
python main.py
deactivate