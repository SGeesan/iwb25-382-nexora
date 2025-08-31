@echo off

set PYTHON_EXE=python
set VENV_NAME=venv

if not exist %VENV_NAME% (
    echo Creating virtual environment...
    %PYTHON_EXE% -m venv %VENV_NAME%

    echo Activating virtual environment for the first time...
    call %VENV_NAME%\Scripts\activate

    echo Upgrading pip...
    pip install --upgrade pip

    echo Installing dependencies...
    pip install -r requirements.txt

    echo Deactivating virtual environment...
    deactivate
)

echo Activating virtual environment...
call %VENV_NAME%\Scripts\activate

echo Running main.py...
python main.py

echo Deactivating virtual environment...
deactivate

pause