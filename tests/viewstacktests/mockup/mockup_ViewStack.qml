import QtQuick 2.0
import ViewStack 1.0

Item {
    width: 480
    height: 640

    Transition {
        id: fadeIn
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 400
            easing.type: Easing.Linear
        }
    }

    Transition {
        id: freeze

        PropertyAction {
            properties: "x,y"
            value: 0
        }

        PauseAnimation {
            duration: 5000
        }
    }

    ViewStack {
        id: stack
        clip: true
        anchors.fill: parent

        stack: ([
            { name: "p1"}
        ])

        model: Item {
            property Component p1 : Component {
                Rectangle {
                    color: "red"
                }
            }

            property Component p2: Component {
                Rectangle {
                    color: "green"
                }
            }

            property Component p3: Component {
                Rectangle {
                    color: "blue"
                }
            }
        }

    }
    states: [
        State {
            name: "p1,p2"
            PropertyChanges {
                target: stack
                stack: [{name: "p1"},
                        {name: "p2"}]
            }
        },
        State {
            name: "p1,p2,p3"
            PropertyChanges {
                target: stack
                stack: [{name: "p1"},
                        {name: "p2"},
                        {
                            name: "p3",
                            pushEnter: fadeIn,
                            pushExit: "freeze",
                            popExit: "fadeOut",
                            popEnter: "freeze"
                        }]
            }
        },
        State {
            name: "p3,p2"
            PropertyChanges {
                target: stack
                stack: [{name: "p3"},
                        {name: "p2"}]
            }
        },
        State {
            name: "p3"
            PropertyChanges {
                target: stack
                stack: [{name: "p3"}]
            }
        }
    ]
}
