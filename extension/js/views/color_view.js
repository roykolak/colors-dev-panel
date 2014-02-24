// Generated by CoffeeScript 1.6.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Panel.Views.ColorView = (function(_super) {

    __extends(ColorView, _super);

    function ColorView() {
      return ColorView.__super__.constructor.apply(this, arguments);
    }

    ColorView.prototype.template = "<div class=\"profile\">\n  <div class=\"swatch\" style=\"background: {{color}}\"></div>\n  <div class=\"formats\">\n    <dl>\n      <dd>{{hex}}</dd>\n      <dd>{{rgb}}</dd>\n      <dd>{{hsl}}</dd>\n    </dl>\n  </div>\n</div>\n<div class=\"color_inputs\">\n  <input type=\"text\" class=\"hex_input\" placeholder=\"hex\" />\n  <input type=\"color\" class=\"color_picker\" />\n</div>";

    ColorView.prototype.events = {
      "input .color_picker": "onColorPickerClick",
      "keyup .hex_input": "onHexInput"
    };

    ColorView.prototype.initialize = function() {
      return this.model.on('change:color', this.render, this);
    };

    ColorView.prototype.render = function() {
      var color, properties;
      color = this.model.get('color');
      properties = _.extend({}, this.model.toJSON(), {
        hex: Panel.Lib.Color.toHexCSS(color),
        rgb: Panel.Lib.Color.toRgbCSS(color),
        hsl: Panel.Lib.Color.toHslCSS(color)
      });
      this.$el.html(Mustache.render(this.template, properties));
      return this;
    };

    ColorView.prototype.onColorPickerClick = function(ev) {
      ev.preventDefault();
      return this.model.set({
        color: $(ev.currentTarget).val()
      });
    };

    ColorView.prototype.onHexInput = function(ev) {
      var value;
      ev.preventDefault();
      value = $(ev.currentTarget).val();
      if (value.length === 7) {
        return this.model.set({
          color: value
        });
      }
    };

    return ColorView;

  })(Backbone.View);

}).call(this);
