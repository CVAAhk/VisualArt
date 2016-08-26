import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

/*!
   \qmltype OmekaToggle

   OmekaToggle is a checkable control with two images representing the checked state
  */
Button {

    id: toggle
    width: dImage.width
    height: dImage.height
    checkable: true

    /*!
        \qmlproperty url OmekaToggle::defaultSource
        Default state image path
    */
    property url defaultSource

    /*!
        \qmlproperty url OmekaToggle::checkedSource
        Checked state image path
    */
    property url checkedSource

    /*!
        \qmlproperty url OmekaToggle::iconScale
        Scale of icon relative to actual file size
    */
    property real iconScale: 1

    property real iconOffsetX: 0

    property real iconOffsetY: 0

    //default state
    Image {
        id: dImage
        source: defaultSource
        visible: !parent.checked
        fillMode: Image.PreserveAspectFit
        width: sourceSize.width * iconScale
        x: toggle.iconOffsetX
        y: toggle.iconOffsetY
    }

    //checked state
    Image {
        source: checkedSource
        visible: parent.checked
        fillMode: Image.PreserveAspectFit
        width: sourceSize.width * iconScale
        x: toggle.iconOffsetX
        y: toggle.iconOffsetY
    }

    //custom background
    style: ButtonStyle { background: Item{} }
}
