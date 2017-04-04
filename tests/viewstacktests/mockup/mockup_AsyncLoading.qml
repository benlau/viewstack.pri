import QtQuick 2.0
import ViewStack 1.0

Item {
    width: 480
    height: 640

    Component {
        id: listPage

        Rectangle {
            color: "white"

            ListView {
                anchors.fill: parent
                model: [
                    { title: "growFadeIn / shrinkFadeOut",
                      pushEnter: "growFadeIn",
                      pushExit: "freeze",
                      popExit: "shrinkFadeOut",
                      popEnter: "freeze"
                    }
                ]

                delegate: Item {
                    property string title: modelData.title
                    width: parent.width
                    height: 48

                    Text {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: 16
                        anchors.topMargin: 16
                        font.pixelSize: 16
                        text: title
                        color: "#DD000000"
                    }
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            viewStack.pushEnter = modelData.pushEnter;
                            viewStack.pushExit = modelData.pushExit;
                            viewStack.popEnter = modelData.popEnter;
                            viewStack.popExit = modelData.popExit;
                            viewStack.stack = ["listPage", {title: "backPage", asynchronous: true}];
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: 0.3
                        visible: mouseArea.pressed
                    }

                    Rectangle {
                        height: 1
                        color: "#1F000000"
                        anchors.bottom: parent.bottom
                        width: parent.width
                    }
                }
            }
        }
    }

    Component {
        id: backPage

        Rectangle {
            color: "black"

            Component.onDestruction: {
                console.log("2nd page destroyed");
            }

            Timer {
                id: debouncer
                interval: 100
                onTriggered: {
                    viewStack.stack = ["listPage"];
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    debouncer.start();
                }
            }

            Text {
                font.pixelSize: 18
                color: "white"
                text: "Back"
                anchors.centerIn: parent
            }

            Rectangle {
                id: mask
                anchors.fill: parent
                color: "#3FFFFFFF"
                visible: mouseArea.pressed
            }
        }
    }


    ViewStack {
        id: viewStack
        anchors.fill: parent
        model: Item {
            property Component listPage : listPage
            property Component backPage: backPage
        }

        stack: ["listPage"]
    }


}
