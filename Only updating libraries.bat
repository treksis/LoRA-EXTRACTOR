@echo off

echo CHECKING AND INSTALLING LIBRARIES
echo.
pip install einops
pip install albumentations
pip install accelerate
pip install diffusers
pip install transformers
pip install tqdm
pip install safetensors
pip install torchvision
pip install pytorch_lightning

echo.
echo CHECKING AND UPDATING OF LIBRARIES IS COMPLETED.
echo.
pause
:nd
:end
exit /b