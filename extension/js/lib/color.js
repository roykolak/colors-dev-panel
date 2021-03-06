// Generated by CoffeeScript 1.6.1
(function() {

  Panel.Lib.Color = {
    Color: function(hex) {
      return net.brehaut.Color(hex);
    },
    range: function(range, callback) {
      var i, _i, _results;
      _results = [];
      for (i = _i = 1; 1 <= range ? _i <= range : _i >= range; i = 1 <= range ? ++_i : --_i) {
        _results.push(callback((100 / range) * i / 100));
      }
      return _results;
    },
    lighten: function(options) {
      var blendColor,
        _this = this;
      blendColor = this.Color('#FFF');
      return this.range(options.steps, function(decimal) {
        return _this.Color(options.rangeStart).blend(blendColor, decimal).toString();
      });
    },
    darken: function(options) {
      var blendColor,
        _this = this;
      blendColor = this.Color('#000');
      return this.range(options.steps, function(decimal) {
        return _this.Color(options.rangeStart).blend(blendColor, decimal).toString();
      });
    },
    saturate: function(options) {
      var _this = this;
      return this.range(options.steps, function(decimal) {
        return _this.Color(options.rangeStart).saturateByRatio(decimal).toString();
      });
    },
    fullSaturation: function(hex) {
      return this.Color(hex).saturateByRatio(1).toString();
    },
    desaturate: function(options) {
      var _this = this;
      return this.range(options.steps, function(decimal) {
        return _this.Color(options.rangeStart).desaturateByRatio(decimal).toString();
      });
    },
    fullDesaturation: function(hex) {
      return this.Color(hex).desaturateByRatio(1).toString();
    },
    blend: function(options) {
      var blendColor,
        _this = this;
      blendColor = this.Color(options.blendColor);
      return this.range(options.steps, function(decimal) {
        return _this.Color(options.rangeStart).blend(blendColor, decimal).toString();
      });
    },
    triadic: function(hex) {
      var color, _i, _len, _ref, _results;
      _ref = this.Color(hex).triadicScheme();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push(color.toString());
      }
      return _results;
    },
    complementary: function(hex) {
      var color, _i, _len, _ref, _results;
      _ref = this.Color(hex).complementaryScheme();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push(color.toString());
      }
      return _results;
    },
    analogous: function(hex) {
      var color, _i, _len, _ref, _results;
      _ref = this.Color(hex).analogousScheme();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push(color.toString());
      }
      return _results;
    },
    neutral: function(hex) {
      var color, _i, _len, _ref, _results;
      _ref = this.Color(hex).neutralScheme();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push(color.toString());
      }
      return _results;
    },
    tetradic: function(hex) {
      var color, _i, _len, _ref, _results;
      _ref = this.Color(hex).tetradicScheme();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push(color.toString());
      }
      return _results;
    },
    sixTone: function(hex) {
      var color, _i, _len, _ref, _results;
      _ref = this.Color(hex).sixToneCWScheme();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push(color.toString());
      }
      return _results;
    },
    toHexCSS: function(hex) {
      return Color(hex).hexString();
    },
    toRgbCSS: function(hex) {
      return Color(hex).rgbString();
    },
    toHslCSS: function(hex) {
      return Color(hex).hslString();
    }
  };

}).call(this);
