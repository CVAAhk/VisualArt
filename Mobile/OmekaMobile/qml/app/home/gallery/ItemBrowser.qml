import QtQuick 2.0

Browser {

    /*! /qmlproperty Number of results per page */
    property int resultsPerPage: 50
    /*! /qmlproperty The expected number of pages when next page is loaded*/
    property int nextCount: 1
    /*! /qmlproperty The number of currently loaded pages*/
    property int pageCount: layout.model ? layout.model.count / 50 : 0
    /*! /qmlproperty The number of columns in the layout*/
    property int columnCount: width/rowHeight
    /*! /qmlproperty The number of rows in the layout*/
    property int rowCount: Math.ceil((resultsPerPage*pageCount)/columnCount)
    /*! /qmlproperty The current heigt of the layout*/
    property real layoutHeight: rowCount * rowHeight
    /*! /qmlproperty The vertical center of the layout*/
    property real layoutCenter: layoutHeight/2;
    /*! /qmlproperty The center of the content relative to the viewport*/
    property real contentY: layout.contentY + headerHeight;

    /*! /qmlsignal Invoked when content meets pagination threshold*/
    signal canPaginate()

    onContentYChanged: pagination()

    /*! Evaluates content position relative to the center of the layout and
        calls signal when the position surpasses the center*/
    function pagination(){
        if(nextCount === pageCount && contentY >= layoutCenter){
            nextCount++;
            canPaginate();
        }
    }
}
