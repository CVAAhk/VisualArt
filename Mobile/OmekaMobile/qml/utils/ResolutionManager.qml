pragma Singleton
import QtQuick 2.0

Item {
    /*! App window */
    property variant appWindow: null
    /*! Total with of app window */
    property int appWidth: appWindow ? appWindow.width : 0
    /*! Total height of app window */
    property int appHeight: appWindow ? appWindow.height: 0
    /*! Width of target widow */
    property int targetWidth: 1440
    /*! Height of target window */
    property int targetHeight: 2464
    /*! Scale relation between target and app resolution */
    property real scaleRatio: screenDiagnol / targetDiagonal
    /*! Diagonal length of the target resolution */
    property real targetDiagonal: Math.sqrt(targetWidth*targetWidth + targetHeight*targetHeight)
    /*! Diagonal length of the current resolution */
    property real screenDiagnol: Math.sqrt(appWidth*appWidth + appHeight*appHeight)
}
