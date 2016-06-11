import QtQuick 2.0

Browser {

    /*! /qmlproperty Number of results per page */
    property int resultsPerPage: 50
    /*! /qmlproperty The expected number of pages when next page is loaded*/
    property int nextCount: 1
    /*! /qmlproperty The number of currently loaded pages*/
    property int pageCount: grid.model.count / 50
    /*! /qmlproperty The number of columns in the grid*/
    property int columnCount: width/grid.cellWidth
    /*! /qmlproperty The number of rows in the grid*/
    property int rowCount: Math.ceil((resultsPerPage*pageCount)/columnCount)
    /*! /qmlproperty The current heigt of the grid*/
    property real gridHeight: rowCount * grid.cellHeight
    /*! /qmlproperty The vertical center of the grid*/
    property real gridCenter: gridHeight/2;
    /*! /qmlproperty The center of the content relative to the viewport*/
    property real contentY: grid.contentY + viewport.height/2;

    /*! /qmlsignal Invoked when content meets pagination threshold*/
    signal canPaginate()

    flickableItem.contentItem.onYChanged: pagination()

    /*! Evaluates content position relative to the center of the grid and
        calls signal when the position surpasses the center*/
    function pagination(){
        if(nextCount === pageCount && contentY >= gridCenter){
            nextCount++;
            canPaginate();
        }
    }
}
