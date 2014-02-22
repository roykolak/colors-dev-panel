// Generated by CoffeeScript 1.6.1
(function() {
  var BlendView, ColorView, ColorsView, RangeView, SchemaView, TabView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  TabView = (function(_super) {

    __extends(TabView, _super);

    function TabView() {
      return TabView.__super__.constructor.apply(this, arguments);
    }

    TabView.prototype.template = "<ul class=\"tabs\">\n  <li class=\"selected\" data-tab=\"lighten\">\n    <a href=\"#\">Lighten</a>\n  </li>\n  <li data-tab=\"darken\">\n    <a href=\"#\">Darken</a>\n  </li>\n  <li data-tab=\"saturate\">\n    <a href=\"#\">Saturate</a>\n  </li>\n  <li data-tab=\"desaturate\">\n    <a href=\"#\">Desaturate</a>\n  </li>\n  <li data-tab=\"blend\">\n    <a href=\"#\">Blend</a>\n  </li>\n  <li data-tab=\"schemas\">\n    <a href=\"#\">Schemas</a>\n  </li>\n</ul>\n<div id=\"tab_content\" style=\"overflow: scroll\"></div>";

    TabView.prototype.events = {
      "click li": "onItemClick"
    };

    TabView.prototype.render = function() {
      this.$el.html(Mustache.render(this.template));
      this.trigger('selection', 'lighten');
      return this;
    };

    TabView.prototype.onItemClick = function(ev) {
      var $el;
      ev.preventDefault();
      $el = $(ev.currentTarget);
      this.$('.selected').removeClass('selected');
      $el.addClass('selected');
      return this.trigger('selection', $el.data('tab'));
    };

    TabView.prototype.update = function($el) {
      return this.$('#tab_content').html($el);
    };

    return TabView;

  })(Backbone.View);

  ColorView = (function(_super) {

    __extends(ColorView, _super);

    function ColorView() {
      return ColorView.__super__.constructor.apply(this, arguments);
    }

    ColorView.prototype.template = "<div class=\"profile\">\n  <div class=\"swatch\" style=\"background: {{color}}\"></div>\n  <div class=\"formats\">\n    <dl>\n      <dt>HEX</dt>\n      <dd>{{color}}</dd>\n    </dl>\n  </div>\n</div>";

    ColorView.prototype.render = function() {
      this.$el.html(Mustache.render(this.template, this.model.toJSON()));
      return this;
    };

    return ColorView;

  })(Backbone.View);

  RangeView = (function(_super) {

    __extends(RangeView, _super);

    function RangeView() {
      return RangeView.__super__.constructor.apply(this, arguments);
    }

    RangeView.prototype.template = "<div class=\"range_colors\"></div>\n<div class=\"range_controls\">\n  <input type=\"range\" id=\"steps\" min=\"3\" max=\"200\" value=\"{{steps}}\">\n  <span><span class=\"steps\">{{steps}}</span> steps</span>\n</div>";

    RangeView.prototype.events = {
      "input #steps": "onStepsChange"
    };

    RangeView.prototype.initialize = function(options) {
      this.mode = options.mode;
      return this.model.on('change:steps', this.renderColors, this);
    };

    RangeView.prototype.render = function() {
      this.$el.html(Mustache.render(this.template, this.model.toJSON()));
      this.renderColors();
      return this;
    };

    RangeView.prototype.renderColors = function() {
      var colorsView;
      colorsView = new ColorsView({
        colors: ColorLib[this.mode](this.model.toJSON())
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

  BlendView = (function(_super) {

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
      colorsView = new ColorsView({
        colors: ColorLib.blend(this.model.toJSON())
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

  ColorsView = (function(_super) {

    __extends(ColorsView, _super);

    function ColorsView() {
      return ColorsView.__super__.constructor.apply(this, arguments);
    }

    ColorsView.prototype.template = "<ol class=\"colors\">\n  {{#colors}}\n    <li style=\"background: {{.}}\">\n      <a href=\"#\" data-color=\"{{.}}\" class=\"color\"></a>\n      <a href=\"#\" data-color=\"{{.}}\" title=\"copy to clipboard\" class=\"fa fa-copy copy\"></a>\n    </li>\n  {{/colors}}\n</ol>";

    ColorsView.prototype.initialize = function(options) {
      return this.colors = options.colors;
    };

    ColorsView.prototype.render = function() {
      this.$el.html(Mustache.render(this.template, {
        colors: this.colors
      }));
      return this;
    };

    return ColorsView;

  })(Backbone.View);

  SchemaView = (function(_super) {

    __extends(SchemaView, _super);

    function SchemaView() {
      return SchemaView.__super__.constructor.apply(this, arguments);
    }

    SchemaView.prototype.template = "<h4>Complementary</h4>\n<div class=\"complementary\"></div>\n<h4>Triadic</h4>\n<div class=\"triadic\"></div>\n<h4>Analogous</h4>\n<div class=\"analogous\"></div>\n<h4>Neutral</h4>\n<div class=\"neutral\"></div>\n<h4>Tetradic</h4>\n<div class=\"tetradic\"></div>\n<h4>SixTone</h4>\n<div class=\"six_tone\"></div>";

    SchemaView.prototype.render = function() {
      this.$el.html(Mustache.render(this.template));
      this.renderColors();
      return this;
    };

    SchemaView.prototype.renderColors = function() {
      var color, view;
      color = this.model.get('color');
      view = new ColorsView({
        colors: ColorLib.complementary(color)
      });
      this.$('.complementary').html(view.render().el);
      view = new ColorsView({
        colors: ColorLib.triadic(color)
      });
      this.$('.triadic').html(view.render().el);
      view = new ColorsView({
        colors: ColorLib.analogous(color)
      });
      this.$('.analogous').html(view.render().el);
      view = new ColorsView({
        colors: ColorLib.sixTone(color)
      });
      this.$('.six_tone').html(view.render().el);
      view = new ColorsView({
        colors: ColorLib.neutral(color)
      });
      this.$('.neutral').html(view.render().el);
      view = new ColorsView({
        colors: ColorLib.tetradic(color)
      });
      return this.$('.tetradic').html(view.render().el);
    };

    return SchemaView;

  })(Backbone.View);

  $(function() {
    var colorView, model, tabView;
    model = new Backbone.Model({
      color: '#4573D5',
      steps: 40,
      blendColor: '#D54545'
    });
    colorView = new ColorView({
      model: model
    });
    $('.side').html(colorView.render().el);
    tabView = new TabView({
      model: model
    });
    tabView.on('selection', function(selection) {
      var view;
      view = (function() {
        switch (selection) {
          case 'schemas':
            return new SchemaView({
              model: this.model
            });
          case 'blend':
            return new BlendView({
              model: this.model
            });
          default:
            return new RangeView({
              model: this.model,
              mode: selection
            });
        }
      }).call(this);
      return this.update(view.render().el);
    }, tabView);
    return $('.main').html(tabView.render().el);
  });

}).call(this);
