// Generated by CoffeeScript 1.6.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Panel.Views.RangeView = (function(_super) {

    __extends(RangeView, _super);

    function RangeView() {
      return RangeView.__super__.constructor.apply(this, arguments);
    }

    RangeView.prototype.template = "<div class=\"range_colors\"></div>\n<div class=\"range_controls\">\n  <input type=\"range\" id=\"steps\" class=\"steps\" min=\"3\" max=\"200\" value=\"{{steps}}\">\n  <span class=\"range_label\"><span class=\"steps\">{{steps}}</span> steps</span>\n</div>";

    RangeView.prototype.events = {
      "input #steps": "onStepsChange"
    };

    RangeView.prototype.initialize = function(options) {
      this.mode = options.mode;
      this.model.on('change:steps', this.renderColors, this);
      return this.model.on('change:color', this.render, this);
    };

    RangeView.prototype.render = function() {
      this.$el.html(Mustache.render(this.template, this.model.toJSON()));
      this.renderColors();
      return this;
    };

    RangeView.prototype.renderColors = function() {
      var colorsView;
      colorsView = new Panel.Views.ColorsView({
        model: this.model,
        colors: Panel.Lib.Color[this.mode](this.model.toJSON())
      });
      return this.$('.range_colors').html(colorsView.render().el);
    };

    RangeView.prototype.onStepsChange = function(ev) {
      var steps;
      steps = parseInt($(ev.currentTarget).val(), 10);
      $('.steps').text(steps);
      return this.model.set({
        steps: steps
      });
    };

    return RangeView;

  })(Backbone.View);

}).call(this);
