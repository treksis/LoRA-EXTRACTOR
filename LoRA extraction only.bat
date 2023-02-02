@echo off

echo LAUNCHING LoRA EXTRACTOR

:fil1
echo.
.\lib\FileToOpen.exe "set fi1=" "%userprofile%\Desktop\*.ckpt;*.safetensors" "Choose a custom model" > %temp_file1%\temp_file1.cmd  

if errorlevel 1 goto :nd

call %temp_file1%\temp_file1.cmd

echo Custom model: %fi1%
echo Fi1=%Fi1%

:fil2
echo.
.\lib\FileToOpen.exe "set fi2=" "%userprofile%\Desktop\*.ckpt;*.safetensors" "Select the base model" > %temp_file2%\temp_file2.cmd  

if errorlevel 2 goto :nd

call %temp_file2%\temp_file2.cmd

if not exist %fi2% (goto fil2)
if %fi2% == %Fi1% (echo The models should be different!
goto fil2)

echo.
echo Basic model: %fi2%
echo Fi2=%Fi2%


:ask_v2
echo.
set "v2=Y"
echo "Have you chosen a checkpoint based on SD2.1? (Y/N): "
set /p v2=Or press [ENTER] to select [%v2%]: 

:ask_dim
echo.
set "dim=300"
echo Enter dim Any number multiple of 8.
echo for example: 8,16,32,64,128,256,300,512,1024,etc.
set /p dim=Or press [ENTER] to select [%dim%]:

:ask_zip
echo.
set "zip=fp16"
echo Enter the compression type (fp16, float)
set /p zip=Or press [ENTER] to select [%zip%]: 


:ask_save
.\lib\FileToSave.exe "set fis=" ".\*.safetensors" "Choose the path to save and the name of LoRA" "" /overwritePrompt > %temp_save%\temp_save.cmd

if errorlevel 1 goto :ask_save

echo.
call %temp_save%\temp_save.cmd
echo The saving path and the name of the LoRA model: %temp_save%
echo fis=%fis%_LoRA%dim%.safetensors

echo.
echo Extraction:

python.exe ./lib/extract_LoRA_from_models.py %v1_2% --save_precision %zip% --save_to %fis%_LoRA%dim%.safetensors --model_org %fi2% --model_tuned %Fi1% --dim %dim%

if /I "%v2%" == "Y" (
    python.exe ./lib/extract_LoRA_from_models.py --save_precision %zip% --save_to %fis%_LoRA%dim%.safetensors --model_org %fi2% --model_tuned %Fi1% --dim %dim% --v2
) else (
    python.exe ./lib/extract_LoRA_from_models.py --save_precision %zip% --save_to %fis%_LoRA%dim%.safetensors --model_org %fi2% --model_tuned %Fi1% --dim %dim%
)



echo.
echo Extraction completed.

echo.
pause
:nd
:end
exit /b