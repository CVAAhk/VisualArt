import QtQuick 2.5

Item {

    /* Maps table user to device */
    readonly property var userToDevice: ({});

    /* Maps device to table user */
    readonly property var deviceToUser: ({});

    /* Returns paired state of user */
    function userIsPaired(user) {
        return user in userToDevice;
    }

    /* Returns paired state of device */
    function deviceIsPaired(device) {
        return device in deviceToUser;
    }

    /* Establishes pairing between table user and device */
    function setPairing(user, device) {
        if(userIsPaired(user) || deviceIsPaired(device)) return false;
        userToDevice[user] = device;
        deviceToUser[device] = user;
        return true;
    }

    /* Releases pairing between table user and device */
    function releasePairing(user, device) {
        if(userIsPaired(user)) {
            delete userToDevice[user];
            delete deviceToUser[device];
            return true;
        }
        return false;
    }

    /* Returns user paired with device */
    function getUserByDevice(device) {
        if(deviceIsPaired(device)) {
            return deviceToUser[device];
        }
    }

    /* Returns device paired with user */
    function getDeviceByUser(user) {
        if(userIsPaired(user)) {
            return userToDevice[user];
        }
    }
}
