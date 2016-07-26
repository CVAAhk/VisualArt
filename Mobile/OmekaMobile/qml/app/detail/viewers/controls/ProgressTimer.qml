import QtQuick 2.0
import QtMultimedia 5.5

/*!
  \qmltype ProgressTimer

  ProgressTime is a custom timer intended to provide better tracking of playback progress
  than native \l MediaPlayer position
*/
Item {

    id: progress

    /*!
      \qmlproperty MediaPlayer ProgressTimer::player
      The media player to track
    */
    property MediaPlayer player

    /*!
      \internal
      Media duration
    */
    property int duration: player ? player.duration : -1

    /*!
      \internal
      Current number of interval cycles
    */
    property int tick: 0

    /*!
      \internal
      Number of permitted ticks
    */
    property int totalTicks: Math.floor(duration / timer.interval)

    /*!
      \internal
      Playback position
    */
    property real position: 0

    /*!
      \internal
      The interval between cycles, in milliseconds
    */
    property alias interval: timer.interval

    /*!
       \qmlsignal ProgressTimer::progressComplete()

        This signal is emitted when media playback is complete.
        The corresponding handler is \c onProgressComplete.
    */
    signal progressComplete()

    //internal timer
    Timer {
        id: timer
        interval: 100
        repeat: true
        onTriggered: progress.onTick()
    }

    //initial play state
    onPlayerChanged:{
        if(!player)
            reset()
        else if(player.playbackState === MediaPlayer.PlayingState)
            run()
    }

    //synch timer with player
    Connections {
        target: player
        onPlaybackStateChanged: {
            switch(player.playbackState){
                case MediaPlayer.PlayingState:
                    run();
                    break;
                case MediaPlayer.PausedState:
                    pause();
                    break;
                default:
                    reset()
                    break;
            }
        }
    }

    /*! \qmlmethod ProgressTimer::pause()
        Pause timer
    */
    function pause() {
        timer.running = false
    }

    /*! \qmlmethod ProgressTimer::run()
        Run timer
    */
    function run() {
        timer.running = true
    }

    /*! \qmlmethod ProgressTimer::reset()
        Reset timer
    */
    function reset() {
        timer.running = false
        tick = 0
        position = 0
    }

    /*! \qmlmethod ProgressTimer::seek(tick)
        Set tick value
    */
    function seek(tick) {
        progress.tick = tick
    }

    /*! \internal
        Evaluate ticks
    */
    function onTick() {
        tick++;
        position = timer.interval * tick
        if(tick === totalTicks){
            progressComplete()
        }
    }
}
