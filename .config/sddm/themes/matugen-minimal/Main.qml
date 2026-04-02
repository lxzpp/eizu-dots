import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: Colors.base

    // 1. BACKGROUND & BLUR
    Item {
        anchors.fill: parent

        Image {
            id: bgWallpaper
            anchors.fill: parent
            source: config.background
            fillMode: Image.PreserveAspectCrop
            visible: false 
        }

        MultiEffect {
            anchors.fill: bgWallpaper
            source: bgWallpaper
            blurEnabled: true
            blurMax: 64
            blur: 1.0
        }
        
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.25 
        }
    }

    // 2. CLOCK MODULE
    ColumnLayout {
        id: clockModule
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -120
        spacing: -10

        Text {
            id: timeText
            text: Qt.formatTime(new Date(), "hh:mm")
            font.family: "JetBrains Mono"
            font.pixelSize: 140
            font.weight: Font.Bold
            color: Colors.text
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            id: dateText
            text: Qt.formatDate(new Date(), "dddd, MMMM dd")
            font.family: "JetBrains Mono"
            font.pixelSize: 22
            font.weight: Font.Bold
            color: Colors.text
            Layout.alignment: Qt.AlignHCenter
        }

        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                timeText.text = Qt.formatTime(new Date(), "hh:mm")
                dateText.text = Qt.formatDate(new Date(), "dddd, MMMM dd")
            }
        }
    }

    // 3. AUTHENTICATION MODULE
    RowLayout {
        id: authModule
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 60
        spacing: 32 

        // Avatar
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            width: 150; height: 150
            radius: 75
            color: Qt.rgba(Colors.surface0.r, Colors.surface0.g, Colors.surface0.b, 0.5)
            border.color: Qt.rgba(Colors.text.r, Colors.text.g, Colors.text.b, 0.5)
            border.width: 3
            clip: true

            Image {
                anchors.fill: parent
                source: sddm.facesDir + "/" + userModel.lastUser + ".face.icon"
                fillMode: Image.PreserveAspectCrop
                onStatusChanged: {
                    if (status == Image.Error) source = ""
                }
            }
        }

        // Details & Input
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 16

            Text {
                text: userModel.lastUser || "User"
                font.family: "JetBrains Mono"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: Colors.text
            }

            Rectangle {
                width: 280
                height: 60
                radius: 30
                color: Qt.rgba(Colors.surface0.r, Colors.surface0.g, Colors.surface0.b, 0.5)
                border.width: 2
                border.color: passwordField.focus ? Colors.text : Qt.rgba(Colors.text.r, Colors.text.g, Colors.text.b, 0.08)
                Behavior on border.color { ColorAnimation { duration: 250 } }

                TextInput {
                    id: passwordField
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: TextInput.Password
                    font.family: "JetBrains Mono"
                    font.pixelSize: 24
                    color: Colors.text
                    focus: true

                    onAccepted: {
                        if (text !== "") {
                            sddm.login(userModel.lastUser, text, sessionModel.lastIndex)
                        }
                    }
                }
            }
        }
    }

    // 4. POWER CONTROLS
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 40
        spacing: 24

        // Suspend
        Rectangle {
            width: 48; height: 48; radius: 24
            color: suspendMa.containsMouse ? Qt.rgba(Colors.mauve.r, Colors.mauve.g, Colors.mauve.b, 0.2) : Qt.rgba(Colors.surface0.r, Colors.surface0.g, Colors.surface0.b, 0.5)
            border.color: suspendMa.containsMouse ? Colors.mauve : Qt.rgba(Colors.text.r, Colors.text.g, Colors.text.b, 0.1)
            
            Text {
                anchors.centerIn: parent
                text: "󰒲"
                font.family: "Iosevka Nerd Font"
                font.pixelSize: 20
                color: suspendMa.containsMouse ? Colors.mauve : Colors.text
            }
            MouseArea {
                id: suspendMa
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.suspend()
            }
        }

        // Reboot
        Rectangle {
            width: 48; height: 48; radius: 24
            color: rebootMa.containsMouse ? Qt.rgba(Colors.blue.r, Colors.blue.g, Colors.blue.b, 0.2) : Qt.rgba(Colors.surface0.r, Colors.surface0.g, Colors.surface0.b, 0.5)
            border.color: rebootMa.containsMouse ? Colors.blue : Qt.rgba(Colors.text.r, Colors.text.g, Colors.text.b, 0.1)
            
            Text {
                anchors.centerIn: parent
                text: "󰜉"
                font.family: "Iosevka Nerd Font"
                font.pixelSize: 20
                color: rebootMa.containsMouse ? Colors.blue : Colors.text
            }
            MouseArea {
                id: rebootMa
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.reboot()
            }
        }

        // Power Off
        Rectangle {
            width: 48; height: 48; radius: 24
            color: powerMa.containsMouse ? Qt.rgba(Colors.red.r, Colors.red.g, Colors.red.b, 0.2) : Qt.rgba(Colors.surface0.r, Colors.surface0.g, Colors.surface0.b, 0.5)
            border.color: powerMa.containsMouse ? Colors.red : Qt.rgba(Colors.text.r, Colors.text.g, Colors.text.b, 0.1)
            
            Text {
                anchors.centerIn: parent
                text: "󰐥"
                font.family: "Iosevka Nerd Font"
                font.pixelSize: 20
                color: powerMa.containsMouse ? Colors.red : Colors.text
            }
            MouseArea {
                id: powerMa
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.powerOff()
            }
        }
    }
}
