var Dog = /** @class */ (function () {
    function Dog(name, age) {
        this._name = name;
        this._age = age;
    }
    Object.defineProperty(Dog.prototype, "name", {
        get: function () {
            return this._name;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Dog.prototype, "age", {
        get: function () {
            return this._age;
        },
        enumerable: false,
        configurable: true
    });
    Dog.prototype.bark = function () {
        console.log("".concat(this._name, ":").concat(this._age, ":: Woof!"));
    };
    Dog.prototype.jump = function (func) {
        func(20);
    };
    Dog.prototype.sleep = function (options) {
        if (options.bed) {
            console.log("".concat(_name, " is sleeping on a ").concat(options.hardness, " bed."));
        }
        else {
            console.log("".concat(_name, " is sleeping on the floor. :("));
        }
    };
    return Dog;
}());
