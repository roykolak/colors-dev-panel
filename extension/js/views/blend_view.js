// Generated by CoffeeScript 1.6.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Panel.Views.BlendView = (function(_super) {

    __extends(BlendView, _super);

    function BlendView() {
      return BlendView.__super__.constructor.apply(this, arguments);
    }

    BlendView.prototype.template = "<div class=\"colors\"></div>\n<div class=\"range_controls\">\n  <input type=\"color\" class=\"color_picker\" id=\"color_picker\" value=\"{{blendColor}}\">\n  <input type=\"range\" id=\"steps\" min=\"3\" max=\"1000\" value=\"20\">\n  <span><span class=\"steps\">{{steps}}</span> steps</span>\n</div>";

    BlendView.prototype.events = {
      "input #steps": "onStepsChange",
      "input #color_picker": "onBlendColorChange"
    };

    BlendView.prototype.initialize = function() {
      this.model.on('change:color', this.render, this);
      this.model.on('change:steps', this.renderColors, this);
      return this.model.on('change:blendColor', this.renderColors, this);
    };

    BlendView.prototype.render = function() {
      this.$el.html(Mustache.render(this.template, this.model.toJSON()));
      this.renderColors();
      return this;
    };

    BlendView.prototype.renderColors = function() {
      var colorsView;
      colorsView = new Panel.Views.ColorsView({
        colors: Panel.Lib.Color.blend(this.model.toJSON()),
        model: this.model
      });
      return this.$('.colors').html(colorsView.render().el);
    };

    BlendView.prototype.onStepsChange = function(ev) {
      var steps;
      steps = parseInt($(ev.currentTarget).val(), 10);
      $('.steps').text(steps);
      return this.model.set({
        steps: steps
      });
    };

    BlendView.prototype.onBlendColorChange = function(ev) {
      return this.model.set({
        blendColor: $(ev.currentTarget).val()
      });
    };

    return BlendView;

  })(Backbone.View);

}).call(this);