@echo off
rem Compile the quad shaders with the Vulkan SDK glslangValidator.
set "GLSLANG=C:\VulkanSDK\1.4.357.0\Bin\glslangValidator.exe"
"%GLSLANG%" -V -S vert psyvk_quad.vert -o psyvk_quad.vert.spv
"%GLSLANG%" -V -S frag psyvk_quad.frag -o psyvk_quad.frag.spv
echo Copy the two .spv files to:
echo   /sdcard/Android/data/DingLing.pe.QuickJs.Engine/files/
