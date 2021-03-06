// Generated by CoffeeScript 1.6.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Panel.Views.RangeView = (function(_super) {

    __extends(RangeView, _super);

    function RangeView() {
      return RangeView.__super__.constructor.apply(this, arguments);
    }

    RangeView.prototype.template = "<div class=\"heading\">\n  Showing <span class=\"steps_count\">{{steps}}</span> steps to <span class=\"end_color\" style=\"background: {{endColor}};\"></span>\n  <div class=\"copy_controls\">\n    copy as:\n    <select class=\"copy_format\">\n      <option value=\"hex\">hex</option>\n      <option value=\"rgb\">rgb</option>\n      <option value=\"hsl\">hsl</option>\n    </select>\n  </div>\n</div>\n<div class=\"range_colors\"></div>\n<div class=\"range_controls\">\n  <input type=\"range\" id=\"steps\" class=\"steps\" min=\"3\" max=\"200\" value=\"{{steps}}\">\n</div>";

    RangeView.prototype.events = {
      "input #steps": "onStepsChange",
      "change .copy_format": "onCopyFormatChange"
    };

    RangeView.prototype.initialize = function(options) {
      this.mode = options.mode;
      this.model.on('change:steps', this.renderColors, this);
      return this.model.on('change:rangeStart', this.render, this);
    };

    RangeView.prototype.render = function() {
      var endColor;
      endColor = (function() {
        switch (this.mode) {
          case 'lighten':
            return '#FFF';
          case 'darken':
            return '#000';
          case 'saturate':
            return Panel.Lib.Color.fullSaturation(this.model.get('color'));
          case 'desaturate':
            return Panel.Lib.Color.fullDesaturation(this.model.get('color'));
        }
      }).call(this);
      this.$el.html(Mustache.render(this.template, _.extend({}, this.model.toJSON(), {
        endColor: endColor
      })));
      this.renderColors();
      return this;
    };

    RangeView.prototype.renderColors = function() {
      var colorsView,
        _this = this;
      colorsView = new Panel.Views.ColorsView({
        model: this.model,
        colors: Panel.Lib.Color[this.mode](this.model.toJSON())
      });
      colorsView.on('select', function(color) {
        return _this.model.set({
          color: color
        });
      });
      return this.$('.range_colors').html(colorsView.render().el);
    };

    RangeView.prototype.onStepsChange = function(ev) {
      var steps;
      steps = parseInt($(ev.currentTarget).val(), 10);
      this.$('.steps_count').text(steps);
      return this.model.set({
        steps: steps
      });
    };

    RangeView.prototype.onCopyFormatChange = function(ev) {
      ev.preventDefault();
      return this.model.set({
        copyFormat: $(ev.currentTarget).val()
      });
    };

    return RangeView;

  })(Backbone.View);

}).call(this);
