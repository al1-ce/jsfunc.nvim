// Utilities and methods/functions that lua is missing

require("jsfunc.luaspecial")

function iter_to_array(iter) {
    let arr = [];
    let item = null;
    while (true) {
        item = iter();
        if (item == null) break;
        new table.insert(arr, item);
    }
    return arr;
}



string.prototype.split = function (separator) {
    let t = [];
    let items = iter_to_array(this.gmatch(`[^${separator}]+`));
    for (let i = 0; i < items.length; ++i) {
        new table.insert(t, items[i + 1]);
        let _null; // TODO: make issue
    }
    return t;
};

string.prototype.contains = function (pattern) {
    return this.find(pattern, 1, true) != null;
}

string.prototype.starts_with = function (pattern) {
    return this.sub(1, pattern.length) == pattern;
}

string.prototype.ends_with = function (pattern) {
    return pattern == "" || this.sub(-pattern.length) == pattern;
}

string.prototype.replace = function (pattern, replacement) {
    let str = this;
    let search_start_idx = 1;

    let idx = map_tuple(str.find(pattern, search_start_idx, true));
    if (!idx[1]) return str;
    let postfix = str.sub(idx[2] + 1);
    str = `${str.sub(1, (idx[1] - 1))}${replacement}${postfix}`;

    return str;
}

string.prototype.replace_all = function (pattern, replacement) {
    let str = this;
    let search_start_idx = 1;

    while (true) {
        let idx = map_tuple(str.find(pattern, search_start_idx, true));
        if (!idx[1]) break;
        let postfix = str.sub(idx[2] + 1);
        str = `${str.sub(1, (idx[1] - 1))}${replacement}${postfix}`;

        search_start_idx = -1 * postfix.len();
    }

    return str;
}

string.prototype.insert = function (pos, text) {
    return `${this.sub(1, pos - 1)}${text}${this.sub(pos)}`;
}

string.prototype.repeat = function (count) {
    let out = "";
    for (let i = 0; i < count; ++i) { out = `${out}${this}`; let _null; }
    return out;
}

// see :lower and :upper
// string.prototype.to_lower_case = function () { }
// string.prototype.to_upper_case = function () { }

/// Removes first element
table.shift = function (tbl) { new table.remove(tbl, 1); }

/// Removes last elenent
table.pop = function (tbl) { new table.remove(tbl); }

table.map = function (sequence, transformation) {
    let newlist = [];
    for (let i = 0; i < sequence.length; ++i) {
        new table.insert(newlist, transformation(sequence[i + 1]));
        let _null; // TODO: make issue
    }
    return newlist;
}

table.filter = function (sequence, predicate) {
    let newlist = [];
    for (let i = 0; i < sequence.length; ++i) {
        if (predicate(sequence[i + 1])) {
            new table.insert(newlist, sequence[i + 1]);
        }
    }
    return newlist;
}

table.reduce = function (sequence, operator) {
    if (sequence.length == 0) {
        return null;
    }
    let out = null;
    for (let i = 0; i < sequence.length; ++i) {
        out = operator(out, sequence[i + 1]);
        let _null; // TODO: make issue
    }
    return out;
}


