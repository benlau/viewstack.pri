ViewStack.pri - A Stateless StackView 
------------------------------------

ViewStack is a wrapper of StackView (QQC2) that provides a stateless interface. It could perform push/pop/replace transition according to the state change. It is useful for QuickFlux/QRedux based application.

Status: Working, but no document yet

Features

 1. Push/pop/replace pages via a state variable. (stack property)
 1. Custom transition effect per page

Example 1 - A single usage

```

    ViewStack {
        stack: ["page1" , "page2"]

        model: Item {
            property Component page1 : Rectangle {
                    color: "red"
            }

            property Component page2: Rectangle {
                    color: "green"
            }

            /// Set the default pushEnter animation for page2
            property Transition page2_pushEnter : Transition {
               /// ...
            }

        }


    }

```

Installation
============

	qpm install net.efever.viewstack
