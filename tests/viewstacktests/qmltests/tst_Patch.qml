import QtQuick 2.0
import QtTest 1.0
import Testable 1.0
import ViewStack 1.0
import "../../../ViewStack/patch.js" as Patch

Item {
    id: window
    height: 640
    width: 480

    TestCase {
        name: "Patch"
        when: windowShown

        function test_normalize() {
            var model = {
                test_pushEnter: "freeze"
            };

            compare(Patch.normalize("test"), [{ name: "test"}]);
            compare(Patch.normalize(["test"]), [{ name: "test"}]);

            compare(Patch.normalize(["test"], model), [{ name: "test", pushEnter: "freeze"}]);

        }

        function test_pop() {
            var model = {
                page2_pushEnter: "fadeIn",
                page2_popExit: "fadeOut",
            };

            var prev = ["page1","page2"];
            var next = ["page1"];
            var result = {
                op: "pop",
                count: 1,
                transitions: {
                    pushEnter: "fadeIn",
                    popExit: "fadeOut"
                }
            };

            compare(Patch.create(prev,next,model), result);
        }

        function test_push() {
            compare(Patch.create([], ["add"]), {op: "push", views: [ {name: "add"}], transitions:{}});
        }

        function test_replace() {
            var prev = ["common","a1"];
            var next = ["common","b1","b2"];
            var result = {
                op: "replace",
                views: [
                    {name: "b1"},
                    {name: "b2"}
                ],
                transitions: {}
            };

            compare(Patch.create(prev,next), result);
        }

        function test_identical() {
            var prev = ["common","a1"];
            var next = ["common","a1"];
            var result = {
                op: "nop",
                transitions: {}
            };

            compare(Patch.create(prev,next), result);
        }

        function test_clear() {
            var prev = ["common","a1","a2"];
            var next = ["common","b1","b2"];
            var result = {
                op: "clear",
                views: [
                    {name: "b1"},
                    {name: "b2"}
                ],
                transitions: {}
            };
            compare(Patch.create(prev,next), result);
        }

        function test_validate() {
            var views = ["common","a1","a2"];
            var n = Patch.normalize(views);
            var model = {
                "a1": {
                }
            }
            n = Patch.validate(model, n);
            compare(JSON.stringify(n), JSON.stringify([{name: "a1"}]));
        }

    }
}
