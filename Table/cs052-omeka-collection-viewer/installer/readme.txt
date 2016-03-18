1. Install the latest Nullsoft scriptable install system.
2. Install and configure FlashDevelop. Build a quick test project to verify it builds and runs properly. 
4. Make sure the run configuration(drop down next to play arrow) is set to Release mode.
5. Run the application to verify it runs and to compile a new swf inside of the bin folder.
6. Use the Swf2Exe converter tool to convert the swf to an executable in the same folder.
7. Once the exe is generated, launch the Large Address Aware tool, load the exe, select the "Large Address Aware Flag" checkbox, and click save. Allow time to complete. This enables the exectuable to recognize when it has access to more memory when on a 64 bit machine.
8. Locate the nullsoft installer script inside of the installer folder,  right click on it, choose "Shell menu..." followed by "Compile NSIS script". This will generate the installer inside of the same folder. 