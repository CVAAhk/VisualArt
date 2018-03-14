# omeka-everywhere/Table2

1. Overview of the application

	-User console browsing/filtering.
	
	the table2 app allows user to browse the collection. Like following image:

	![browsing](OmekaTable2/content/readme/browse.PNG)

	the table2 app allows user to filter based on the keyword. Like following image:

	![](OmekaTable2/content/readme/filter.PNG)
		
	-Content viewers and metadata.
	
	![](OmekaTable2/content/readme/detail.PNG)
		
	-Generating a heist session.
	
	![](OmekaTable2/content/readme/pairing.PNG)

2. Requirements

	-Environment Setup
	
	 	Qt 5.9.2 MSVC2013 64bit kit
	 
	-Omeka REST API(http://omeka.readthedocs.io/en/latest/Reference/api/). API must be set to public on targeted site.
	
	-heist plugins(https://omeka.org/classic/docs/Plugins/Heist/).

3. Build Instructions

	-How to build the OmekaTable2.
	1. Pull the latest build from Github.
	2. Open build from Qt Creator.
	3. Select Qt 5.9.2 MSVC2013 64bit build kit.
	4. Make sure the build is set to release mode, select Build in the toolbar, then select Rebuild Project "OmekaTable2".
	5. Qt Quick Deployment(e.g.: http://doc.qt.io/qt-5/windows-deployment.html#the-windows-deployment-tool)
	
	   Make sure the file structure looks like:
	
		Table2(parent directory)

		-OmekaTable2(project folder contains main.qml, all other QML files and ui)

		-release(build folder contains the compiled binary and it's dependencies.)
	
	6. Run OmekaTable2.exe to open the application.

	
4. Configuration and Customization
	
	-The location of key files in the project structures.
	
		Styling(OmekaTable2/Style.qml)

		ui assets(OmekaTable2/content/)

		endpoint editing(OmekaTable2/settings.js)
	
	-Here is the tutorial of QML.(http://doc.qt.io/qt-5/qml-tutorial.html)
		
	-Locate build folder(eg. Table2/OmekaTable2). Open settings.js. 

		var USERS = 4(# of users. By default, it's 4. It can only be changed to 2 or 4 or 6).

		var OMEKA_ENDPOINT = "http://dev.omeka.org/mallcopy/" (Displaying endpoint. It can be changed to any supported endpoint.)


		

