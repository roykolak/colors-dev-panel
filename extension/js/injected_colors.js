// Generated by CoffeeScript 1.6.1
(function() {
  var bringAttentionToEl, colorElementMap, interval, properties;

  colorElementMap = {};

  interval = null;

  properties = ['color', 'backgroundColor'];

  chrome.extension.onMessage.addListener(function(message, sender) {
    var color, colors, cssProperty, el, prop, _base, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref, _ref1, _ref2, _results, _results1, _results2;
    switch (message.label) {
      case 'fetch_palette':
        colorElementMap = {
          color: {},
          backgroundColor: {}
        };
        colors = {
          color: [],
          backgroundColor: []
        };
        _ref = document.querySelectorAll('*');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          el = _ref[_i];
          for (_j = 0, _len1 = properties.length; _j < _len1; _j++) {
            cssProperty = properties[_j];
            color = getComputedStyle(el)[cssProperty];
            if (color && color !== 'transparent') {
              if ((_ref1 = (_base = colorElementMap[cssProperty])[color]) == null) {
                _base[color] = [];
              }
              colorElementMap[cssProperty][color].push(el);
              if (colors[cssProperty].indexOf(color) === -1) {
                colors[cssProperty].push(color);
              }
            }
          }
        }
        return chrome.extension.sendMessage(colors);
      case 'sync':
        _results = [];
        for (_k = 0, _len2 = properties.length; _k < _len2; _k++) {
          prop = properties[_k];
          _results.push((function() {
            var _l, _len3, _ref2, _results1;
            _ref2 = message.color;
            _results1 = [];
            for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
              color = _ref2[_l];
              _results1.push((function() {
                var _len4, _m, _ref3, _results2;
                _ref3 = colorElementMap[prop][color] || [];
                _results2 = [];
                for (_m = 0, _len4 = _ref3.length; _m < _len4; _m++) {
                  el = _ref3[_m];
                  _results2.push(el.style[prop] = message.newColor);
                }
                return _results2;
              })());
            }
            return _results1;
          })());
        }
        return _results;
        break;
      case 'color_to_sync_selected':
        _results1 = [];
        for (_l = 0, _len3 = properties.length; _l < _len3; _l++) {
          prop = properties[_l];
          _results1.push((function() {
            var _len4, _m, _ref2, _results2;
            _ref2 = message.color;
            _results2 = [];
            for (_m = 0, _len4 = _ref2.length; _m < _len4; _m++) {
              color = _ref2[_m];
              _results2.push((function() {
                var _len5, _n, _ref3, _results3;
                _ref3 = colorElementMap[prop][color] || [];
                _results3 = [];
                for (_n = 0, _len5 = _ref3.length; _n < _len5; _n++) {
                  el = _ref3[_n];
                  _results3.push(bringAttentionToEl(el));
                }
                return _results3;
              })());
            }
            return _results2;
          })());
        }
        return _results1;
        break;
      case 'color_to_sync_highlight':
        cssProperty = message.cssProperty, color = message.color;
        _ref2 = colorElementMap[cssProperty][color] || [];
        _results2 = [];
        for (_m = 0, _len4 = _ref2.length; _m < _len4; _m++) {
          el = _ref2[_m];
          _results2.push(bringAttentionToEl(el, color, cssProperty));
        }
        return _results2;
        break;
      case 'color_to_sync_unhighlight':
    }
  });

  bringAttentionToEl = function(el, color, cssProperty) {
    el.style[cssProperty] = 'transparent';
    return setTimeout((function() {
      return el.style[cssProperty] = color;
    }), 250);
  };

}).call(this);
