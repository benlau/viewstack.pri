/* ViewStack - A Stateful StackView
 */
import QtQuick 2.4
import QtQuick.Controls 2.0
import "./patch.js" as Patch

Item {
    id: component

    /* This property represents the content of views in this component. It can be an array of string
      or object and mixed content. ViewStack will load and arrange its content according to this
      property

      e.g

      stack: [ "view1", "view2" ]

      stack: [
        { title: "view1",
          options: {
           /// ...
          },
          pushEnter: fadeIn,
          pushExit: idle
        },
        {
          title: "view2",
          options: {
           /// ...
          }
        }
      ]
     */

    property var stack: new Array

    /* This property represents a table of view delegate and transition effect to be shown by this component.

      e.g

      models: Item {
        property Component page1 : Item {
          ...
        }

        property Component page2 : Item {
          ...
        }

        property var page2_pushEnter: "fadeIn"
        property var page2_popExit: Transition {
          ...
        }
      }

     */
    property var model: ({})

    property alias initItem: stackView.initialItem

    property var pushEnter

    property var pushExit

    property var popEnter

    property var popExit

    property var replaceEnter

    property var replaceExit

    property var transitionTable: transitionTable

    QtObject {
        // Private variable
        id: priv
        /// Normalized view stack information
        property var stack: new Array
    }

    QtObject {
        /* Built-in transition table */
        id: transitionTable

        property Transition fadeIn : Transition {
            PropertyAction {
                property: "x"
                value: 0
            }

            PropertyAction {
                property: "y"
                value: 0
            }

            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 400
                easing.type: Easing.Linear
            }
        }

        property Transition growFadeIn: Transition {

            PropertyAction {
                property: "transformOrigin"
                value: Item.Center
            }

            NumberAnimation {
                from: 0.9
                to: 1
                property: "scale"
                duration: 100
                easing.type: Easing.Linear
            }

            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 100
                easing.type: Easing.Linear
            }
        }

        property Transition fadeOut : Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 400
                easing.type: Easing.Linear
            }
        }

        property Transition shrinkFadeOut: Transition {

            PropertyAction {
                property: "transformOrigin"
                value: Item.Center
            }

            NumberAnimation {
                from: 1
                to: 0.9
                property: "scale"
                duration: 100
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 100
                easing.type: Easing.Linear
            }
        }


        property Transition freeze: Transition {

            PauseAnimation {
                duration: 100
            }
        }

        /// This move entering view onto the screen from the appropriate side
        property Transition moveInRight: Transition {
            ParallelAnimation {
                NumberAnimation { property:"x";from:  component.width ;to: 0;duration: 400;easing.type: Easing.OutCubic}
            }
        }        

        property Transition moveOutRight: Transition {
            ParallelAnimation {
                NumberAnimation { property:"x";from: 0 ;to:  component.width;duration: 400;easing.type: Easing.OutCubic}
            }
        }

        property Transition moveInLeft: Transition {
            ParallelAnimation {
                NumberAnimation { property: "x"; from:  -component.width;to: 0;duration: 400;easing.type: Easing.OutCubic}
            }
        }
    }

    QtObject {
        id: systemDefaultTransition
        property Transition popEnter: transitionTable.freeze

        property Transition popExit: transitionTable.moveOutRight

        property Transition pushEnter: transitionTable.moveInRight

        property Transition pushExit: transitionTable.freeze

        property Transition replaceEnter: transitionTable.moveInRight

        property Transition replaceExit:  transitionTable.freeze
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }

    function refresh() {
        var viewsNormalized = Patch.normalize(stack, component.model);
        viewsNormalized = Patch.validate(model, viewsNormalized);
        var patch = Patch.create(priv.stack, viewsNormalized);
        priv.stack = viewsNormalized;

        /* Update transition table */
        var config = Patch.createTransitionConfig(patch.transitions,
                                                          component,
                                                          systemDefaultTransition);
        Patch.applyTransition(stackView, config, transitionTable);

        /* Update StackView */
        if (patch.op === "push") {
            stackView.push.call(null, Patch.args(model, patch.views));
        } else if (patch.op === "pop"){
            while (patch.count--) {
                stackView.pop();
            }
        } else if (patch.op === "replace") {
            stackView.replace.call(null, Patch.args(model, patch.views));
        } else if (patch.op === "clear") {
            stackView.clear();
            if (patch.views.length > 0) {
                stackView.push.call(null, Patch.args(model, patch.views));
            }
        }
    }

    onStackChanged: {
        refresh();
    }
}
