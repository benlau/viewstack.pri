.pragma library

var transitions = ["pushEnter","pushExit", "popEnter", "popExit", "replaceEnter", "replaceExit"];

function _normalize(input, model) {
    var res = input;

    if (typeof res === "string") {
        res = {
            title: input
        }
    }

    if (typeof model === "object") {
        for (var i in transitions) {
            var trans = transitions[i];
            var modelTrans = res.title + "_" + trans;

            if (!res.hasOwnProperty(trans) &&
                model.hasOwnProperty(modelTrans)) {
                res[trans] = model[modelTrans];
            }
        }

    }

    return res;
}

function normalize(input, model) {
    if (Array.isArray(input)) {
        return input.map(function(item) {
            return _normalize(item, model)
        });
    } else {
        return [_normalize(input, model)];
    }
}

/// Compare the input until they are not matched, return the non-match part
function _diff(prev, next) {
    var s = 0;
    for (var i = 0 ; i < prev.length && i < next.length;i++) {
        if (prev[i].title !== next[i].title) {
            break;
        }
        s++;
    }

    return [prev.slice(s),next.slice(s)];
}

function _pickTransitions(item) {
    var res = {}
    for (var i in transitions) {
        var t = transitions[i];
        if (item.hasOwnProperty(t)) {
            res[t] = item[t];
        }
    }
    return res;
}

/// Construct arguments according to the model for StackView.push/replace
function args(model, views) {
    var res = [];

    for (var i in views) {
        var v = views[i];

        res.push(model[v.title]);
        res.push(v.options);
    }

    return res;
}

function create(prev, next, model) {
    var p = normalize(prev, model);
    var n = normalize(next, model);

    var d = _diff(p, n);

    if (d[0].length === 0 && d[1].length === 0) {
        return {
            op: "nop",
            transitions: {}
        }
    } else if (d[0].length === 0 && d[1].length > 0) {
        // push
        return {
            op: "push",
            views: d[1],
            transitions: _pickTransitions(d[1][0])
            // TODO: Handle the case that multiple items to be popped
        }
    } else if (d[1].length === 0 && d[0].length > 0){
        // pop
        return {
            op: "pop",
            count: d[0].length,
            transitions: _pickTransitions(d[0][0])
        }
    } else if (d[0].length <= 1) {
        // Replace
        return {
            op: "replace",
            views: d[1],
            transitions: _pickTransitions(d[1][0])
        }
    } else {
        // It should clear the whole stack and replace with the new content
        return {
            op: "clear",
            views: d[1],
            transitions: _pickTransitions(d[1][0])
        }
    }
}

function createTransitionConfig() {
    var table = {}

    for (var i in transitions) {
        var t = transitions[i];

        for (var j in arguments) {
            var config = arguments[j];
            if (config[t] !== undefined) {
                table[t] = config[t];
                break;
            }
        }
    }
    return table;
}

function applyTransition(stackView,config, transitionTable) {
    for (var i in transitions) {
        var t = transitions[i];

        var value = config[t];
        if (typeof value === "string") {
            stackView[t] = transitionTable[value];
        } else {
            stackView[t] = value;
        }
    }
}

function validate(model, nView) {
    var res = [];

    for (var i = 0; i < nView.length; i++) {
        var view = nView[i];
        if (!model.hasOwnProperty(view.title)) {
            console.warn("ViewStack: Unknown view: " + view.title);
        } else {
            res.push(view);
        }
    }
    return res;
}
