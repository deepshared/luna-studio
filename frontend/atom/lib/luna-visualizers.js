// Generated by CoffeeScript 1.12.7
(function() {
  var fs, getVisualizersForPath, importedVisualizers, internalVisName, internalVisualizers, listVisualizers, lunaBaseVisPath, lunaVisName, lunaVisPath, lunaVisualizers, normalizeVis, path, projectVisualizers, resolveVis;

  path = require('path');

  fs = require('fs');

  lunaBaseVisPath = path.join(__dirname, 'visualizers');

  internalVisName = 'internal';

  lunaVisName = 'data';

  lunaVisPath = path.join(lunaBaseVisPath, lunaVisName);

  internalVisualizers = [];

  lunaVisualizers = [];

  projectVisualizers = [];

  importedVisualizers = {};

  listVisualizers = function(visPath, name) {
    var dirs;
    if (!fs.existsSync(visPath)) {
        console.log("========= visualisers: !fs.existsSync(%s)", visPath);
      return [];
    } else {
      dirs = [];
      if (name != null) {
        dirs = [name];
      } else {
        dirs = fs.readdirSync(visPath);
      }
      console.log("========= visualisers: dirs: %s", dirs);
      return dirs.filter(function(p) {
        return fs.existsSync(path.join(visPath, p, "config.js"));
      });
    }
  };

  resolveVis = function(p, name) {
    return normalizeVis(p, name, require(path.join(p, name, "config.js")));
  };

  normalizeVis = function(p, name, visConf) {
    return function(cons) {
      var f, filesToLoad, i, len;
      filesToLoad = cons != null ? visConf(JSON.parse(cons)) : visConf();
      if (filesToLoad != null) {
        for (i = 0, len = filesToLoad.length; i < len; i++) {
          f = filesToLoad[i];
          f.path = path.join(name, f.path);
        }
        return JSON.stringify(filesToLoad);
      } else {
        return JSON.stringify(null);
      }
    };
  };

  getVisualizersForPath = function(path, name) {
    var i, len, n, result, visualizers;
    visualizers = listVisualizers(path, name);
    result = {};
    for (i = 0, len = visualizers.length; i < len; i++) {
      n = visualizers[i];
      result[n] = resolveVis(path, n);
    }
    return result;
  };

  module.exports = function() {
    window.getInternalVisualizersPath = function() {
      return lunaBaseVisPath;
    };
    window.getInternalVisualizers = function() {
      internalVisualizers = getVisualizersForPath(lunaBaseVisPath, internalVisName);
      return internalVisualizers;
    };
    window.getLunaVisualizersPath = function() {
      return lunaVisPath;
    };
    window.getLunaVisualizers = function() {
      lunaVisualizers = getVisualizersForPath(lunaVisPath);
      return lunaVisualizers;
    };
    window.getProjectVisualizers = function(path) {
      projectVisualizers = getVisualizersForPath(path);
      return projectVisualizers;
    };
    window.getImportedVisualizers = function(libName, path) {
      importedVisualizers[libName] = getVisualizersForPath(path);
      return importedVisualizers[libName];
    };
    window.checkInternalVisualizer = function(name) {
      return internalVisualizers[name]();
    };
    window.checkLunaVisualizer = function(name, tpeRep) {
      return lunaVisualizers[name](tpeRep);
    };
    window.checkProjectVisualizer = function(name, tpeRep) {
      return projectVisualizers[name](tpeRep);
    };
    return window.checkImportedVisualizer = function(libName, name, tpeRep) {
      return importedVisualizers[libName][name](tpeRep);
    };
  };

}).call(this);
