import QtQuick 2.0
import "."

Item
{
    property var letters: []

    id: root

    x: 165
    y: 65

    signal letterSelected(string letter);

    Repeater
    {
        model: 26

        OmekaText
        {
            _font: Style.filterFont
            rootScale: 2.0

            y: index * 6.5
            width: 10
            center: true

            color: 'gray'

            text:  String.fromCharCode(0x41 + index);

            MultiPointTouchArea
            {
                anchors.fill: parent

                onReleased:
                {
                    root.selectLetter(index, true);
                }
            }
        }

        onItemAdded:
        {
            root.letters.push(item);
        }
    }

    function selectLetter(index, emitUpdate)
    {
        var letterHeight = 0;
        for(var i = 0; i != letters.length; i++)
        {
            var letter = letters[i];

            letter.y = letterHeight;

            if(index == i)
            {
                letter.rootScale = 1.0;
                letter.color = 'black';
                letterHeight += 13;
            }
            else
            {
                letter.rootScale = 2.0;
                letter.color = 'gray';
                letterHeight += 6.5;
            }
        }

        if(emitUpdate)
        {
            root.letterSelected(String.fromCharCode(0x41 + index));
        }
    }

    function selectLetterChar(letter)
    {
        var index = letter.toUpperCase().charCodeAt(0) - 0x41;
        selectLetter(index);
    }

    function letterTapped(index)
    {
        selectLetter(index);
    }
}
