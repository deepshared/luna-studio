// Generated by CoffeeScript 1.12.7
var eventFilters, globalRegistry, listeners, removeFromArray;

removeFromArray = (function(_this) {
  return function(array, elt) {
    var index;
    index = array.indexOf(elt);
    return array.splice(index, 1);
  };
})(this);

listeners = {
  onEvent: [],
  onNotification: []
};

globalRegistry = {};

eventFilters = {
  blockedEvents: [],
  allowedEvents: [],
  expectedEvents: []
};

module.exports = {
  connector: (function(_this) {
    return function(otherGlobal) { 
     return globalRegistry = otherGlobal;
    };
  })(this),
  setActiveLocation: (function(_this) {
    return function(location) {
      console.warn("setActiveLocation.cb: %s", location);
      return globalRegistry.activeLocation = location;
    };
  })(this),
  pushNotification: (function(_this) {
    return function(lvl, msg) {
      console.warn("pushNotification.cb: %s", msg);
      if (listeners.onNotification.length === 0) {
        switch (lvl) {
          case 0:
          case 1:
            console.error(msg);
            break;
          case 2:
            console.warn(msg);
            break;
          default:
            return console.log(msg);
        }
      } else {
        return listeners.onNotification.forEach(function(callback) {
          return callback({
            level: lvl,
            message: msg
          });
        });
      }
    };
  })(this),
  onNotification: (function(_this) {
    return function(listener) {
      console.warn("onNotification.cb: %s", listener);
      return listeners.onNotification.push(listener);
    };
  })(this),
  onEvent: (function(_this) {
    return function(listener) {
      console.warn("onEvent.cb: %s", listener);
      return listeners.onEvent.push(listener);
    };
  })(this),
  unOnEvent: (function(_this) {
    return function(listener) {
      console.warn("unOnEvent.cb: %s",listener );
      return removeFromArray(listeners.onEvent, listener);
    };
  })(this),
  pushEvent: (function(_this) {
    return function(data) {
      console.warn("pushEvent.cb: %s", data);
      return listeners.onEvent.forEach(function(listener) {
        return listener(data);
      });
    };
  })(this),
  setEventFilter: (function(_this) {
    return function(blocked, allowed, expected) {
      console.warn("setEventFilter.cb !!!!!!!!!!!!!!!!!!!", );
      return eventFilters = {
        blockedEvents: blocked,
        allowedEvents: allowed,
        expectedEvents: expected
      };
    };
  })(this),
  onExpectedEvent: (function(_this) {
    return function(callback) {
      console.warn("onExpectedEvent.cb: %s", callback);
      return listeners.onExpectedEvent = callback;
    };
  })(this),
  acceptEvent: (function(_this) {
    return function(event) {
      var eventMatchesRestriction, isExpected, matchesAllowed, matchesBlocked, noRestrictions;
      // console.warn("acceptEvent.cb: %s", event);
      event = JSON.parse(event);
      eventMatchesRestriction = function(evt, restriction) {
        var eventNameMatches, nodeInfo, nodeName, nodeNameMatches, portId, portIdMatches, ref, ref1, searcherInput, searcherInputMatches;
        nodeInfo = evt.eventInfo.nodeInfo;
        nodeName = nodeInfo != null ? nodeInfo.nodeName : void 0;
        portId = nodeInfo != null ? (ref = nodeInfo.portInfo) != null ? ref.portId : void 0 : void 0;
        searcherInput = (ref1 = evt.eventInfo.searcherInfo) != null ? ref1.input : void 0;
        eventNameMatches = restriction.regexp.test(event.name);
        nodeNameMatches = (restriction.nodeName == null) || (restriction.nodeName === nodeName);
        portIdMatches = (restriction.portId == null) || (restriction.portId === portId);
        searcherInputMatches = (restriction.searcherInput == null) || (restriction.searcherInput === searcherInput);
        return eventNameMatches && nodeNameMatches && portIdMatches && searcherInputMatches;
      };
      isExpected = eventFilters.expectedEvents.some(function(restriction) {
        return eventMatchesRestriction(event, restriction);
      });
      if (isExpected) {
        if (listeners != null) {
          if (typeof listeners.onExpectedEvent === "function") {
            listeners.onExpectedEvent();
          }
        }
        return isExpected;
      } else {
        noRestrictions = eventFilters.blockedEvents.length === 0 && eventFilters.allowedEvents.length === 0;
        matchesAllowed = eventFilters.allowedEvents.some(function(restriction) {
          return eventMatchesRestriction(event, restriction);
        });
        matchesBlocked = eventFilters.blockedEvents.some(function(restriction) {
          return eventMatchesRestriction(event, restriction);
        });
        return noRestrictions || matchesAllowed || !(eventFilters.blockedEvents.length === 0 || matchesBlocked);
      }
    };
  })(this)
};
