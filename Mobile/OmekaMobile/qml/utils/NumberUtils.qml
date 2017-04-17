pragma Singleton
import QtQuick 2.5

Item {

    function map(num, min1, max1, min2, max2) {
        if(num < min1) return min2;
        if(num > max1) return max2;
        var num1 = (num - min1) / (max1 - min1)
        return (num1 * (max2 - min2)) + min2
    }

    function randomInt(min, max) {
        return Math.floor(Math.random()*(max-min)+min);
    }

}
