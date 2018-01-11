Installer Developer’s Guide
This guide is to help get OmekaTable2 installer.


What you will need:
Nullsoft Scriptable Install System (NSIS) http://nsis.sourceforge.net/Download
Qt 5.9.2 MSVC2013 64bit kit

Step 1: Get the Installer Scripts


Step 2: Copy your application to the files folder(current build is already copied to installer folder)
The Installer script will use the files within the files folder to compile your application into an installation executable. 


-For QT Quick Applications: Make sure to name the folder your .exe is in Executable. There is a Macro setting for QT applications that looks for the Executable folder.

-How to build the OmekaTable2.
Get the latest build from Github.
Open build from Qt Creator
Select Qt 5.9.2 MSVC2013 64bit kit
Run application in Release mode
Qt Quick Deployment using windeployqt.exe

Step 3: Compile
Right-Click on the OmekaTable2.nsi file and click Compile. This will compile the code and give you a new installer with the files you supplied in the files folder. If there are errors within your script it will tell you in the console log of the NSIS Compile Window. This process may take a few minutes.

**NOTE** If you are getting errors in the compiler the code may have switched encodings!!!!!!
Open up a text editor (NotePad++ allows for encoding changes) and switch the encoding
to UTF-8. Save and try compiling again.


Step 7: Test
Make sure your installer works. The installer should be able to create a desktop shortcut, uninstaller.
