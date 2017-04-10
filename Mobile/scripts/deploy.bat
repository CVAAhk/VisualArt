PUSHD c:\Qt\5.5\msvc2013_64\bin
START /W windeployqt.exe --qmldir c:\repo\omeka-everywhere\Mobile\OmekaMobile c:\repo\omeka-everywhere\Mobile\Builds\Desktop\debug
POPD
ROBOCOPY c:\repo\omeka-everywhere\Mobile\Builds\Desktop\debug  files\application\debug /mir
ROBOCOPY c:\repo\omeka-everywhere\Mobile\OmekaMobile files\application\omeka /mir