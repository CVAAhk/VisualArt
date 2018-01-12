Installer Developer’s Guide
This guide is to help get OmekaTable2 installer.


What you will need:
Nullsoft Scriptable Install System (NSIS) http://nsis.sourceforge.net/Download
Qt 5.9.2 MSVC2013 64bit kit

Step 1: Get the Installer Script
It's at Table2/Installer/OmekaTable2.nsi


Step 2: Build the OmekaTable2 application in Qt Creator. 


-For QT Quick Applications: Make sure to name the folder your .exe is in Executable. There is a Macro setting for QT applications that looks for the Executable folder.

-How to build the OmekaTable2.
1. Pull the latest build from Github.
2. Open build from Qt Creator
3. Select Qt 5.9.2 MSVC2013 64bit build kit
4. Run application in Release mode
 Make sure the build is set to release mode, select Build in the toolbar, then select Rebuild Project "OmekaTable2".
5. Qt Quick Deployment using windeployqt.exe
 a)Open the command prompt
 b)Navigate to the Qt install’s 'bin' folder (cf. “Application Location”)
 c)Run the following command:
		> windeployqt.exe    --qmldir    APP_QML_DIR    APP_BINARY_DIR

Step 3: Locate the release folder from your build directory ( e.g. Builds/release), which contains the compiled binary and it's dependencies. Then copy the OmekaTable2( at Table2) and release folder to the installer foler at Table2/Installer/OmekaTable2. Rename the release foler to Executable.( current build is already copied to installer folder.)
The Installer script will use the files within the OmekaTable2 folder to compile your application into an installation executable. 

Step 3: Compile
Right-Click on the OmekaTable2.nsi file and click Compile. This will compile the code and give you a new installer with the files you supplied in the files folder. If there are errors within your script it will tell you in the console log of the NSIS Compile Window. This process may take a few minutes.

**NOTE** If you are getting errors in the compiler the code may have switched encodings!!!!!!
Open up a text editor (NotePad++ allows for encoding changes) and switch the encoding
to UTF-8. Save and try compiling again.


Step 7: Test
Make sure your installer works. The installer should be able to create a desktop shortcut, uninstaller.
