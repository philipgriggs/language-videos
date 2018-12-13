import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.5
import QtMultimedia 5.0

App {
    // You get free licenseKeys from https://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://v-play.net/licenseKey>"

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
            source: "../assets/La La Land 1.m4v"
            autoPlay: false

            MouseArea {
                anchors.fill: parent
                onClicked: playPause()
            }

            focus: true
            Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
            Keys.onLeftPressed: skipBack()
            Keys.onRightPressed: skipForward()
        }

        Nav {
            id: nav
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 40
        }
    }

    Timer {
        id: displayTimer
        interval: 20
        running: video.playbackState === MediaPlayer.PlayingState
        repeat: true
        onTriggered: {

            var currTime = video.position

            if (currIdx !== -1 && pause && !readyToDelete && currTime >= endTime[currIdx]) {
                video.pause()
                prevIdx = -1
                readyToDelete = true
            } else {
                currIdx = getBin(currTime, startTime, endTime)

                if (currIdx >= 0 && currIdx !== prevIdx) {
                    entityManager.removeAllEntities()

                    var currStr = str[currIdx]
                    var currAns = ans[currIdx]

                    pause = false
                    for(var i=0; i<currAns.length; i++) {
                        if(currAns[i] !== "") {
                            currAns[i] = currAns[i].replace(/.?/g, '_')
                            pause = true
                        }
                    }

                    var props = {
                        x: 0,
                        y: page.height - 40,
                        width: page.width,
                        str: currStr,
                        ans: currAns,
                        repeats: currStr.length,
                        entityId: "SubText",
                        video: video
                    }

                    var entityId = entityManager.createEntityFromUrlWithProperties(
                                Qt.resolvedUrl("Subtext.qml"),
                                props
                            );
                    var entity = entityManager.getEntityById(entityId)

                    for(i=0; i<currStr.length; i++) {
                        var txtObj = entity.repeater.itemAt(i).txtObj
                        txtObj[0].width = txtObj[0].paintedWidth
                        txtObj[1].width = txtObj[2].paintedWidth
                    }

                    prevIdx = currIdx
                    readyToDelete = false
                } else if (readyToDelete) {
                    entityManager.removeAllEntities()
                    prevIdx = currIdx
                    readyToDelete = false
                }
            }
        }
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
        if (currIdx !== -1) {
            if (video.position < startTime[currIdx]+200) {
                var idx = getPrevBin(startTime[currIdx]-10, startTime)
                if (idx === -1){
                    video.seek(video.position - 5000)
                } else {
                    video.seek(startTime[idx])
                }
            } else {
                console.log("seeking to " + startTime[currIdx] + " " + currIdx)
                video.seek(startTime[currIdx])
            }
        } else {
            idx = getPrevBin(video.position, startTime)
            if (idx === -1){
                video.seek(video.position - 5000)
            } else {
                video.seek(startTime[idx])
            }
        }
        if (video.playbackState === MediaPlayer.PausedState){
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

    function getBin(xq, xStart, xEnd) {
        var i = 0
        if (xq<xStart[0]) return -1
        for (i=0; i<xStart.length; i++){
            if (xq>=xStart[i] && xq<xEnd[i]){
                return i
            }
        }
        return -1
    }

    function getPrevBin(xq, xStart){
        var i = 0
        for (i=0; i<xStart.length; i++){
            if (xq<xStart[i]){
                break
            }
        }
        return i-1
    }

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

    function strSplit(str) {
        var strRe = /^[^<].+?<|>.*?<|>.+$/g
        var ansRe = /<.*?>/g

        var strIdx = []
        var ansIdx = []

        var match = strRe.exec(str)
        while (match != null) {
            strIdx.push(match.index)
            match = strRe.exec(str)
        }

        match = ansRe.exec(str)
        while (match != null) {
            ansIdx.push(match.index)
            match = ansRe.exec(str)
        }

        if (strIdx.length > 0 || ansIdx.length>0) {
            var strMatch = str.match(/^[^<].+?<|>.*?<|>.+$/g)
            if(strMatch !== null) {
                for (var i=0; i<strMatch.length; i++){
                    strMatch[i] = strMatch[i].replace(/<|>/g, '');
                }

                if(strIdx[0] > ansIdx[0]) {
                    strMatch.unshift("")
                }
            } else {
                strMatch = [""]
            }

            var ansMatch = str.match(/<.*?>/g)
            if (ansMatch !== null) {
                for (i=0; i<ansMatch.length; i++){
                    ansMatch[i] = ansMatch[i].replace(/<|>/g, '');
                }

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
