import QtQuick 2.6

/**
    ----------------------------------------------------------------------------
    EXAMPLE USAGE:
    ----------------------------------------------------------------------------
    Rectangle
    {
        id: test_rect
        x: 1420; y: 580
        width: 700; height: 700
        color: "hotpink"

        MultiPointPinchArea
        {
            parent: test_rect                      // must be set for bounds checks to work
            anchors.fill: test_rect
            listenForDrag: true                    // defaults to true
            listenForRotation: false               // defaults to true
            listenForScale: false                  // defaults to true
            dragOnPinch: false                     // defaults to false
            maximumScale: 3                        // only set if bounded AND listenForScale = true
            minimumScale: 0.5                      // only set if bounded AND listenForScale = true
            maximumRotation: 180                   // only set if bounded AND listenForRotation = true
            minimumRotation: -180                  // only set if bounded AND listenForRotation = true
            maximumX: 3840 - test_rect.width       // only set if bounded AND listenForDrag AND/OR dragOnPinch = true
            minimumX: 0                            // only set if bounded AND listenForDrag AND/OR dragOnPinch = true
            maximumY: 2160 - test_rect.height      // only set if bounded AND listenForDrag AND/OR dragOnPinch = true
            minimumY: 0                            // only set if bounded AND listenForDrag AND/OR dragOnPinch = true

            onPositionUpdated:
            {
                test_rect.x += delta_x;
                test_rect.y += delta_y;
            }
            onRotationUpdated:
            {
                test_rect.rotation += delta_rotation;
            }
            onScaleUpdated:
            {
                test_rect.scale += delta_scale;
            }
        }
    }
  */

MultiPointTouchArea
{
    //=========================================================================
    // ROOT ITEM PROPERTIES
    //=========================================================================
    // settings for which type of signals to receive (drag, rotate, scale, drag
    // on pinch)
    property bool listenForDrag: true
    property bool listenForRotation: true
    property bool listenForScale: true
    property bool dragOnPinch: false

    // maximum and minimum rotation to be set by instantiating items (target
    // item MUST be set as parent to work correctly)
    property real maximumRotation: Number.POSITIVE_INFINITY
    property real minimumRotation: Number.NEGATIVE_INFINITY

    // maximum and minimum scale to be set by instantiating items (target
    // item MUST be set as parent to work correctly)
    property real maximumScale: Number.POSITIVE_INFINITY
    property real minimumScale: 0.0

    // position boundaries to be set by instantiating items(target
    // item MUST be set as parent to work correctly)
    property real maximumX: Number.POSITIVE_INFINITY
    property real minimumX: Number.NEGATIVE_INFINITY
    property real maximumY: Number.POSITIVE_INFINITY
    property real minimumY: Number.NEGATIVE_INFINITY

    // values used internally for calculations
    property vector2d previousPosition: Qt.vector2d(0, 0)
    property real previousPinchAngle: 0.0
    property real previousPinchDistance: 0.0

    property bool pinching: false
    property bool dragging: false

    property bool debugView: false

    //=========================================================================
    // ROOT ITEM SETTINGS
    //=========================================================================
    id: root
    mouseEnabled: false
    touchPoints: [TouchPoint{id: touch_1}, TouchPoint{id: touch_2}]
    minimumTouchPoints: 1
    maximumTouchPoints: 2

    //=========================================================================
    // SIGNALS
    //=========================================================================
    signal positionUpdated(real delta_x, real delta_y)
    signal rotationUpdated(real delta_rotation)
    signal scaleUpdated(real delta_scale)
    signal itemPressed()

    // Just for debugging
    Rectangle
    {
        color: "red"
        opacity: 0.5
        anchors.fill: parent
        visible: root.debugView
    }

    //=========================================================================
    // FUNCTIONS
    //=========================================================================
    //-------------------------------------------------------------------------
    // SIGNAL HANDLING
    //-------------------------------------------------------------------------
    onPressed:
    {
        if(touch_1.pressed && touch_2.pressed)
        {
            root.pinching = true;
            if(root.listenForRotation)
            {
                root.previousPinchAngle = root.getCurrentPinchAngle();
            }
            if(root.listenForScale)
            {
                root.previousPinchDistance = root.getCurrentPinchDistance();
            }
            if(root.dragOnPinch)
            {
                root.previousPosition = root.getPinchPosition();
            }
        }
        else
        {
            if(root.dragging)
            {
                root.pinching = true;
                root.dragging = false;
                if(root.listenForRotation)
                {
                    root.previousPinchAngle = root.getCurrentPinchAngle();
                }
                if(root.listenForScale)
                {
                    root.previousPinchDistance = root.getCurrentPinchDistance();
                }
                if(root.dragOnPinch)
                {
                    root.previousPosition = root.getPinchPosition();
                }
            }
            else
            {
                root.dragging = true;
                if(root.listenForDrag)
                {
                    root.previousPosition = root.getCurrentPosition(touch_1.pressed ? touch_1 : touch_2);
                }
            }
        }

        root.itemPressed();
    }
    onUpdated:
    {
        if(touch_1.pressed && touch_2.pressed)
        {
            if(root.dragging)
            {
                root.dragging = false;
                root.pinching = true;
                if(root.listenForRotation)
                {
                    root.previousPinchAngle = root.getCurrentPinchAngle();
                }
                if(root.listenForScale)
                {
                    root.previousPinchDistance = root.getCurrentPinchDistance();
                }
                if(root.dragOnPinch)
                {
                    root.previousPosition = root.getPinchPosition();
                }
            }
            else
            {
                if(root.listenForRotation)
                {
                    root.updateRotation();
                }
                if(root.listenForScale)
                {
                    root.updateScale();
                }
                if(root.dragOnPinch)
                {
                    root.updatePinchPosition();
                }
            }
        }
        else
        {
            if(root.pinching)
            {
                root.dragging = true;
                root.pinching = false;
                if(root.listenForDrag)
                {
                    root.previousPosition = root.getCurrentPosition(touch_1.pressed ? touch_1 : touch_2);
                }
            }
            else
            {
                if(root.listenForDrag)
                {
                    root.updatePosition(touch_1.pressed ? touch_1 : touch_2);
                }
            }
        }
    }
    onReleased:
    {
        if(root.pinching)
        {
            root.pinching = false;
            if(touch_1.pressed || touch_2.pressed)
            {
                root.dragging = true;
                if(root.listenForDrag)
                {
                    root.previousPosition = root.getCurrentPosition(touch_1.pressed ? touch_1 : touch_2);
                }
            }
        }
        else if(root.dragging)
        {
            root.dragging = false;
        }
    }
    //-------------------------------------------------------------------------
    // CALLED
    //-------------------------------------------------------------------------
    ////////////////////////////////////////////////////////// UPDATE FUNCTIONS
    function updatePosition(touch_point)
    {
        var curr_pos = root.getCurrentPosition(touch_point);
        var dx = curr_pos.x - root.previousPosition.x;
        var dy = curr_pos.y - root.previousPosition.y;

        // check boundaries and emit signal if within boundaries
        var new_x = parent.x + dx;
        var new_y = parent.y + dy;
        dx = root.checkXBounds(dx, new_x, curr_pos);
        dy = root.checkYBounds(dy, new_y, curr_pos);
        root.positionUpdated(dx, dy);
    }
    function updatePinchPosition()
    {
        var curr_pos = root.getPinchPosition();
        var dx = curr_pos.x - root.previousPosition.x;
        var dy = curr_pos.y - root.previousPosition.y;

        // check boundaries and emit signal if within boundaries
        var new_x = parent.x + dx;
        var new_y = parent.y + dy;
        dx = root.checkXBounds(dx, new_x, curr_pos);
        dy = root.checkYBounds(dy, new_y, curr_pos);
        root.positionUpdated(dx, dy);
    }
    function updateRotation()
    {
        var curr_angle = root.getCurrentPinchAngle();
        var dr = root.getAngleDifference(curr_angle, root.previousPinchAngle);

        // check boundaries and emit signal
        parent.rotation %= 360.0;
        var new_rot = parent.rotation + dr;
        dr = root.checkRotationBounds(dr, new_rot, curr_angle);
        root.rotationUpdated(dr);
    }
    function updateScale()
    {
        var curr_dist = root.getCurrentPinchDistance();
        var dist_diff = curr_dist - root.previousPinchDistance;
        var ds = dist_diff/root.previousPinchDistance;

        // check boundaries and emit signal if within boundaries
        var new_scale = parent.scale + ds;
        ds = root.checkScaleBounds(ds, new_scale, curr_dist);
        root.scaleUpdated(ds);
    }
    ///////////////////////////////////////////////////// CALCULATION FUNCTION
    function getCurrentPosition(touch_point)
    {
        return Qt.vector2d(touch_point.sceneX, touch_point.sceneY);
    }
    function getPinchPosition()
    {
        var small_x = Math.min(touch_1.sceneX, touch_2.sceneX);
        var small_y = Math.min(touch_1.sceneY, touch_2.sceneY);
        var half_diff_x = Math.abs(touch_2.sceneX - touch_1.sceneX) * 0.5;
        var half_diff_y = Math.abs(touch_2.sceneY - touch_1.sceneY) * 0.5;

        return Qt.vector2d(small_x + half_diff_x, small_y + half_diff_y);
    }
    function getCurrentPinchAngle()
    {
        var angle_1 = (Math.atan2((touch_1.sceneY - touch_2.sceneY), (touch_1.sceneX - touch_2.sceneX)) + 180.0) * (180.0/Math.PI);
        var angle_2 = (Math.atan2((touch_2.sceneY - touch_1.sceneY), (touch_2.sceneX - touch_1.sceneX)) + 180.0) * (180.0/Math.PI);

        var diff_1 = root.getAngleDifference(root.previousPinchAngle, angle_1);
        var diff_2 = root.getAngleDifference(root.previousPinchAngle, angle_2);

        return (Math.abs(diff_1) < Math.abs(diff_2)) ? angle_1 : angle_2;
    }
    function getCurrentPinchDistance()
    {
        var dx_squared = (touch_2.sceneX - touch_1.sceneX) * (touch_2.sceneX - touch_1.sceneX);
        var dy_squared = (touch_2.sceneY - touch_1.sceneY) * (touch_2.sceneY - touch_1.sceneY);
        return Math.sqrt(dx_squared + dy_squared);
    }
    function getAngleDifference(angle_1, angle_2)
    {
        var difference = angle_1 - angle_2;
        if(difference < 0)
        {
            return (difference < -180.0) ? (-360.0 - difference) : difference;
        }
        else
        {
            return (difference > 180.0) ? (360.0 - difference) : difference;
        }
    }
    //////////////////////////////////////////////////// BOUNDS CHECK FUNCTIONS
    function checkRotationBounds(dr, new_rot, curr_angle)
    {
        // check bounds and update dr and previous pinch angle accordingly
        if(new_rot < (root.minimumRotation % 360.0))
        {
            dr = root.minimumRotation - parent.rotation;
            root.previousPinchAngle = curr_angle + dr;
        }
        else if(new_rot > (root.maximumRotation % 360.0))
        {
            dr = root.maximumRotation - parent.rotation;
            root.previousPinchAngle = curr_angle + dr;
        }
        else
        {
            root.previousPinchAngle = curr_angle;
        }
        return dr;
    }
    function checkScaleBounds(ds, new_scale, curr_dist)
    {
        if(new_scale < root.minimumScale)
        {
            ds = root.minimumScale - parent.scale;
            root.previousPinchDistance = curr_dist + ds;
        }
        else if(new_scale > root.maximumScale)
        {
            ds = root.maximumScale - parent.scale;
            root.previousPinchDistance = curr_dist + ds;
        }
        else
        {
            root.previousPinchDistance = curr_dist;
        }
        return ds;
    }
    function checkXBounds(dx, new_x, curr_pos)
    {
        if(new_x < root.minimumX)
        {
            dx = root.minimumX - parent.x;
            root.previousPosition.x = curr_pos.x + dx;
        }
        else if(new_x > root.maximumX)
        {
            dx = root.maximumX - parent.x;
            root.previousPosition.x = curr_pos.x + dx;
        }
        else
        {
            root.previousPosition.x = curr_pos.x;
        }
        return dx;
    }
    function checkYBounds(dy, new_y, curr_pos)
    {
        if(new_y < root.minimumY)
        {
            dy = root.minimumY - parent.y;
            root.previousPosition.y = curr_pos.y + dy;
        }
        else if(new_y > root.maximumY)
        {
            dy = root.maximumY - parent.y;
            root.previousPosition.y = curr_pos.y + dy;
        }
        else
        {
            root.previousPosition.y = curr_pos.y;
        }
        return dy;
    }
}
