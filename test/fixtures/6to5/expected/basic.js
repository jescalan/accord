"use strict";

var _inherits = function (child, parent) {
  if (typeof parent !== "function" && parent !== null) {
    throw new TypeError("Super expression must either be null or a function, not " + typeof parent);
  }
  child.prototype = Object.create(parent && parent.prototype, {
    constructor: {
      value: child,
      enumerable: false,
      writable: true,
      configurable: true
    }
  });
  if (parent) child.__proto__ = parent;
};

var Test = (function () {
  var _TestClass = TestClass;
  var Test = function Test(greeting) {
    this.greeting = greeting;
  };

  _inherits(Test, _TestClass);

  Test.defaultGreeting = function () {
    return "hello there!";
  };

  return Test;
})();