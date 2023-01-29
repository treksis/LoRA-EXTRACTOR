@echo off

echo LAUNCHING LoRA EXTRACTOR
echo.
:fil1
.\lib\FileToOpen.exe "set fi1=" "%userprofile%\Desktop\*.ckpt;*.safetensors" "Choose a custom model" > %temp_file1%\temp_file1.cmd  

if errorlevel 1 goto :nd

call %temp_file1%\temp_file1.cmd

echo Custom model: %fi1%
echo Fi1=%Fi1%
echo.



:fil2
.\lib\FileToOpen.exe "set fi2=" "%userprofile%\Desktop\*.ckpt;*.safetensors" "Select the base model" > %temp_file2%\temp_file2.cmd  

if errorlevel 2 goto :nd

call %temp_file2%\temp_file2.cmd

if not exist %fi2% (goto :fil2)
if %fi2% == %Fi1% (echo The models should be different!
goto :fil2)
echo.

echo Basic model: %fi2%
echo Fi2=%Fi2%
echo.


:ask_dim
set "dim=128"
echo Enter dim (4-8-16-32-64-128-256-360)
set /p dim=Or press [ENTER] to select [%dim%]:

echo.

:ask_zip
set "zip=float"
echo Enter the compression type (fp16, float)
set /p zip=Or press [ENTER] to select [%zip%]: 


:ask_save
.\lib\FileToSave.exe "set fis=" ".\*.safetensors" "Choose the path to save and the name of LoRA" "Default_LoRA.safetensors" /overwritePrompt > %temp_save%\temp_save.cmd
@echo off
echo.

if errorlevel 1 goto :end

call %temp_save%\temp_save.cmd
echo The saving path and the name of the LoRA model: %temp_save%
echo fis=%fis%
echo.


:launch
echo Extraction:
python.exe ./lib/extract_LoRA_from_models.py --save_precision %zip% --save_to %fis% --model_org %fi2% --model_tuned %Fi1% --dim %dim%

echo.
echo Extraction completed.
echo.
pause
:nd
:end
exit /b