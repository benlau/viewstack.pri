ViewStack.pri - A Stateful StackView 
------------------------------------

ViewStack is a wrapper of StackView (QQC2) that provides a stateful interface. It could perform push/pop/replace transition according to the state change. It is useful for QuickFlux/QRedux based application.

Status: Working, but no document yet

Features

 1. Push/pop/replace pages via a state variable. (stack property)
 1. Custom transition effect per page

Example:
```

    ViewStack {
        clip: true
        anchors.fill: parent

        stack: (["page1" , "page2]);

        model: Item {
            property Component page1 : Component {
                Rectangle {
                    color: "red"
                }
            }

            property Component page2: Component {
                Rectangle {
                    color: "green"
                }
            }
        }
        
        property Transition page2_pushEnter : Transition {
           /// ...
        }

    }

```
