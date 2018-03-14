# omeka-everywhere/Mobile

1. Requirements

	-Environment Setup
	
		Qt 5.5.1 MSVC2013 64bit
		Android for armeabi-v7a(GCC 4.9, Qt 5.5.1 for Android armv72) (for deploying Android)
	 
	-Omeka REST API(http://omeka.readthedocs.io/en/latest/Reference/api/). API must be set to public on targeted site.
	
	-heist plugins(https://omeka.org/classic/docs/Plugins/Heist/).

2. Build Instructions

	-How to build the OmekaMobile.
	1. Pull the latest build from Github.
	2. Open build from Qt Creator.
	3. Select Qt 5.5.1 MSVC2013 64bit build kit.
	4. Make sure the build is set to release mode, select Build in the toolbar, then select Rebuild Project "OmekaMobile".
	5. Qt Quick Deployment using windeployqt.exe.
	
	 	a)Open the command prompt.
		
	 	b)Navigate to the Qt install’s 'bin' folder (cf. “Application Location”) .
		
	 	c)Run the following command:
		
			> windeployqt.exe    --qmldir    APP_QML_DIR    APP_BINARY_DIR
	
	-Get the exe.
	
	Locate the release folder from your build directory ( e.g. Builds/release), which contains the compiled binary and it's dependencies.
	
3. User Guide

	-Configuration - endpoint
	
	Locate at Mobile/OmekaMobile/qml/clients/HeistClient.qml
	
	property url endpoint: "http://dev.omeka.org/mallcopy/" ( you can change this to any supported endpoint)
		
	-Vertical scroll browsing on the home feed.
	
	![browsing](OmekaMobile/screenshots/scroll.PNG)
	
	-Item exploration (pan/zoom images, playback video/audio, slideshow, metadata)
	
	![](OmekaMobile/screenshots/detail.PNG)
		
	-Local storage of liked items (either directly or through heist plugin)
	
	![](OmekaMobile/screenshots/filter.PNG)
		
	-Settings (layout, site list, heist pairing)
	
	![](OmekaMobile/screenshots/settings.PNG)
	
	-Heist plugin (site must have the plugin installed to use but mobile does not have to target same endpoint as table in order to accept content from that table)

4. Customization

	-The location of key files in the project structures.
	
	Styling(OmekaMobile/utils/Style.qml)
	
	ui assets(OmekaMobile/ui/)
	
	-Here is the tutorial of QML.(http://doc.qt.io/qt-5/qml-tutorial.html)
		
		

