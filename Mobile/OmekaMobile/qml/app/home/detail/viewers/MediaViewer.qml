import QtQuick 2.5

Image {
    id: img       
    width: parent.width
    fillMode: Image.PreserveAspectFit
    asynchronous: true
    scale: width > sourceSize.width ? width / sourceSize.width : 1
}
