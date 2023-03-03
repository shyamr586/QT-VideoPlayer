import QtQuick
import QtQuick.Dialogs
import QtMultimedia
import QtQuick.Layouts


Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Video Player")
    color: "#01cdfe"
    ColumnLayout{
        id:parentcolumn
        spacing: 2
        anchors.fill: parent

        Rectangle {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 10
            color: "#ff71ce"
            Layout.preferredWidth: 200
            height: 50
            radius:50
            Text{
                id:buttontext
                width: parent.width
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 15
                font.bold: true
                font.family: "Helvetica [Cronyx]"
                text:"Open Video"
                anchors.fill: parent

            }

            MouseArea{
                anchors.fill: parent
                onClicked: {fileDialog.open()}
            }
        }

        Rectangle{
            id: canvas

            color:"black"
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins:20

            VideoOutput{
                id: videoOutput
                anchors.fill: parent

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        playHandler()
                    }
                }
            }
        }

        RowLayout{
            id: videocontrols
            width: parent.width
            spacing:1
            Layout.alignment: Qt.AlignBottom

           Rectangle{
               id:pauseplay
               height:20
               width:20
               color:"transparent"
               Layout.margins: 10

               Image{
                   id: playbutton
                   height: parent.height
                   width: parent.width
                   source: "https://cdn-icons-png.flaticon.com/512/527/527995.png"
               }

               MouseArea{
                   anchors.fill: parent
                   onClicked: playHandler()
               }
           }

           Rectangle{
               id: progressbar
               width: parent.width
               Layout.rightMargin: 20
               height:10
               Layout.fillWidth: true
               color: "#fffb96"
               Rectangle{
                   id: slider
                   height:10
                   width:10
                   color:"#b967ff"
                   border.color: "black"

                   MouseArea{
                       anchors.fill: parent
                       drag.target: parent
                       drag.axis: Drag.XAxis
                       drag.maximumX: progressbar.width - parent.width
                       drag.minimumX: 0
                       onPositionChanged: {
                           mediaplayer.position = slider.x/ (progressbar.width - slider.width) * mediaplayer.duration
                       }
                   }
               }
           }
        }

    }

        MediaPlayer{
            id: mediaplayer
            videoOutput: videoOutput
            audioOutput: AudioOutput {}
            onPositionChanged: {
                slider.x = position/duration * (progressbar.width - slider.width)
            }
        }

    FileDialog{
        id: fileDialog
        title: "Choose video"
        nameFilters: ["Video files (*.mp4 *.avi *.mkv *.mov *.wmv *.flv *.mpeg)"]
        onAccepted: {
            buttontext.text = "Open another Video"
            mediaplayer.source = fileDialog.selectedFile
            mediaplayer.play()
            playbutton.source = "https://cdn-icons-png.flaticon.com/512/2088/2088562.png"

        }
    }

    function playHandler(){
        if (mediaplayer.playbackState === MediaPlayer.PlayingState){
            mediaplayer.pause()
            playbutton.source = "https://cdn-icons-png.flaticon.com/512/527/527995.png"
        }
        else if (mediaplayer.playbackState === MediaPlayer.PausedState){
            mediaplayer.play()
            playbutton.source = "https://cdn-icons-png.flaticon.com/512/2088/2088562.png"
        }

        //(mediaplayer.playbackState === MediaPlayer.PlayingState) ?
        //            mediaplayer.pause():mediaplayer.play()
    }


}

