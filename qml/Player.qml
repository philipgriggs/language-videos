import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.5
import QtMultimedia 5.0

Item {
    // You get free licenseKeys from https://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://v-play.net/licenseKey>"

    property string fileName: "../assets/La La Land 1.m4v"

    EntityManager {
        id: entityManager
        entityContainer: page
    }

    Page {
        id: page

        Component.onCompleted: {
            parseJson("../assets/subs.json")
        }

        Rectangle {
            color: "black"
            anchors.fill: parent
        }

        Video {
            id: video
            anchors.fill: parent
            source: fileName
            autoPlay: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    // hideNavTimer.start()
                    // playPause()
                    video.focus = true
                }

                onMouseYChanged: {
                    nav.opacity = 1.0;
                    hideNavTimer.restart()
                }

                onEntered: {
                    nav.opacity = 1.0;
                    hideNavTimer.restart()
                }
            }

            focus: true
            Keys.onSpacePressed: {
                if (video.playbackState === MediaPlayer.PlayingState) {
                    video.pause()
                } else {
                    dispCurrSub()
                    skipBack()
                }
            }
            Keys.onLeftPressed: skipBack()
            Keys.onRightPressed: skipForward()
        }

        Nav {
            id: nav
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 40
            Behavior on opacity {NumberAnimation {duration: 500} }
        }
    }

    Timer {
        id: hideNavTimer
        running: false
        repeat: false
        interval: 5000
        onTriggered: nav.opacity=0
    }

    Timer {
        id: runDownTimer
        running: false
        repeat: false
        interval: 50
        onTriggered: {
            if(currIdx !== -1 && video.position > startTime[currIdx]) {
                // fire displayTimer after run down has elapsed via property bindings
                repeat = false
            }
        }
    }

    Timer {
        id: displayTimer
        interval: 20
        running: video.playbackState === MediaPlayer.PlayingState && !runDownTimer.running
        repeat: true
        onTriggered: dispCurrSub()
    }

    property var startTime: []
    property var endTime: []
    property var str: []
    property var ans: []
    property int currIdx: -1
    property int prevIdx: -1
    property bool readyToDelete: false
    property bool pause: false

    function playPause() {
        if (video.playbackState === MediaPlayer.PlayingState) {
            video.pause()
        } else {
            video.play()
        }
    }

    function skipBack() {
        video.pause()
        var currPosn = video.position
        var seekIdx = currIdx

        // if we're not in between subs
        if(seekIdx !== -1) {
            // seek isn't exact, so make sure we go back before the requested timerText
            // by at least one frame, then start a runDownTimer so we don't get a pause
            // from the previous subs overlapping
            video.seek(startTime[seekIdx])
            currPosn = video.position

            var i = 10
            var targetPosn = startTime[seekIdx]
            while(currPosn >= targetPosn) {
                video.seek(currPosn - i)
                currPosn = video.position
                i += 10
            }

            // wait for the amount surplus that we skipped back, plus a margin for error
            currIdx = seekIdx
            runDownTimer.repeat = true
            runDownTimer.start()
        }

        if (video.playbackState === MediaPlayer.PausedState) {
            video.play()
        }
    }

    function skipForward() {
        var idx = getNextBin(video.position, startTime)
        if (idx === startTime.length) {
            video.seek(video.position + 5000)
        } else {
            video.seek(startTime[idx])
        }
        if (video.playbackState === MediaPlayer.PausedState){
            video.play()
        }
    }

    // get the current video position and decides which subtitle is needed on the screen
    function dispCurrSub() {
        var currTime = video.position

        // Pause at the end of the current subtitle, but we have to make
        // sure we've exceeded the current subtitle bin by one frame,
        // otherwise we won't be able to advance beyond the current pause.
        // Checks:
        // 1. we are not in a gap where there are no subs (currIdx !== 1)
        // 2. there was a gap to fill in the current sub (pause === true)
        // 3. since we are already in the next bin, we tell the timer not to pause on the next frame (readyToDelete = true)
        if (currIdx !== -1 && pause && !readyToDelete && currTime >= endTime[currIdx]) {
            video.pause()
            prevIdx = -1
            readyToDelete = true
        } else {
            currIdx = getBin(currTime, startTime, endTime)

            // delete and replace the current subs if the video position advanced to the next bin
            if (currIdx >= 0 && currIdx !== prevIdx) {
                entityManager.removeAllEntities()

                var currStr = str[currIdx].slice()
                var currBlank = ans[currIdx].slice()
                var currAns = ans[currIdx].slice()
                var blanksLength = 0
                var rightAns = []

                // check whether the current subtitle has a missing blank
                pause = false
                for(var i=0; i<currAns.length; i++) {
                    if(currAns[i] !== "") {
                        currBlank[i] = currBlank[i].replace(/.?/g, '_')
                        pause = true
                        blanksLength++
                        rightAns.push(0)
                    }
                }

                var props = {
                    x: 0,
                    y: page.height - 40,
                    width: page.width,
                    str: currStr,
                    ans: currAns,
                    blank: currBlank,
                    nAnsNeeded: blanksLength,
                    rightAns: rightAns,
                    repeats: currStr.length,
                    entityId: "SubText",
                    video: video,
                    ccButton: nav.ccButton,
                }

                var entityId = entityManager.createEntityFromUrlWithProperties(
                            Qt.resolvedUrl("Subtext.qml"),
                            props
                            );
                var entity = entityManager.getEntityById(entityId)

                // set the width of each text object to wrap to the word length (paintedWidth)
                for(i=0; i<currStr.length; i++) {
                    var txtObj = entity.repeater.itemAt(i).txtObj
                    txtObj[0].width = txtObj[0].paintedWidth
                    txtObj[1].width = txtObj[2].paintedWidth
                }

                prevIdx = currIdx
                readyToDelete = false
            } else if (readyToDelete) {
                // we have exceeded the endTime (readyToDelete === true) and are in a gap with no subtitles
                entityManager.removeAllEntities()
                prevIdx = currIdx
                readyToDelete = false
            }
        }
    }

    // get the index where xStart[i] <= xq < xEnd[i]
    function getBin(xq, xStart, xEnd){
        var i = 0
        if (xq<xStart[0]) return -1
        for (i=0; i<xStart.length; i++){
            if (xq>=xStart[i] && xq<xEnd[i]){
                return i
            }
        }
        return -1
    }

    // get the index of the bin one before the current time
    function getPrevBin(xq, xStart){
        var i = 0
        for (i=0; i<xStart.length; i++){
            if (xq<xStart[i]){
                break
            }
        }
        return i-1
    }

    // get the index of the bin one after the current time
    function getNextBin(xq, xStart){
        var i = 0
        for (i=0; i<xStart.length; i++){
            if (xq<xStart[i]){
                break
            } else if (i==xStart.length-1){
                return xStart.length
            }
        }
        return i
    }

    // extract the json subtitles into arrays of startTime [ms], endTime [ms], subtitles and blanks
    function parseJson(file) {
        var document = fileUtils.readFile(Qt.resolvedUrl(file))
        var jsonObj = JSON.parse(document)

        for (var i=0; i<jsonObj.data.length; i++){
            startTime.push(jsonObj.data[i].start*1000)
            endTime.push(jsonObj.data[i].end*1000)

            var strToAdd = strSplit(jsonObj.data[i].str)
            str.push(strToAdd[0])
            ans.push(strToAdd[1])
        }
    }

    // Split the string into subtitles and blanks - words in <brackets> are replaced by blanks.
    // Because we are using a repeater, the return array of subtitles (str) and blanks (ans) must be the same length.
    function strSplit(str) {
        var strRe = /^[^<].+?<|>.*?<|>.+$/g
        var ansRe = /<.*?>/g

        var strIdx = []
        var ansIdx = []

        // get the index of the str matches (non-blanks)
        var match = strRe.exec(str)
        while (match != null) {
            strIdx.push(match.index)
            match = strRe.exec(str)
        }

        // get the index of the blanks
        match = ansRe.exec(str)
        while (match != null) {
            ansIdx.push(match.index)
            match = ansRe.exec(str)
        }

        if (strIdx.length > 0 || ansIdx.length>0) {
            // get the subtitle values
            var strMatch = str.match(/^[^<].+?<|>.*?<|>.+$/g)
            if(strMatch !== null) {
                // trim the leading and trailing '<>' (since negative look ahead/behind is not supported)
                for (var i=0; i<strMatch.length; i++){
                    strMatch[i] = strMatch[i].replace(/<|>/g, '');
                }

                // we require a pattern: [str, ans, str, ans, ...]
                // so add an empty str if the first item is a blank
                if(strIdx[0] > ansIdx[0]) {
                    strMatch.unshift("")
                }
            } else {
                strMatch = [""]
            }

            // get the blanks values
            var ansMatch = str.match(/<.*?>/g)
            if (ansMatch !== null) {
                // trim the leading and trailing '<>' (since negative look ahead/behind is not supported)
                for (i=0; i<ansMatch.length; i++){
                    ansMatch[i] = ansMatch[i].replace(/<|>/g, '');
                }

                // so add an empty str if the last item is a subtitle
                if(strIdx[strIdx.length-1] > ansIdx[ansIdx.length-1]) {
                    ansMatch.push("")
                }
            } else {
                ansMatch = [""]
            }

            return [strMatch, ansMatch]
        }

        return [[str],[""]]
    }

}
