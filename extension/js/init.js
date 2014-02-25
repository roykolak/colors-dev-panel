// Generated by CoffeeScript 1.6.1
(function() {
  var model;

  model = new Backbone.Model({
    color: '#4573D5',
    rangeStart: '#4573D5',
    steps: 40,
    blendColor: '#D54545',
    palette: ['#CCC']
  });

  model.on('change:color', function() {
    var color;
    if (model.get('syncColor')) {
      if (chrome.runtime != null) {
        color = model.get('syncColor');
        return chrome.runtime.connect().postMessage({
          label: 'sync',
          color: [Panel.Lib.Color.toHexCSS(color), Panel.Lib.Color.toRgbCSS(color), Panel.Lib.Color.toHslCSS(color)],
          newColor: model.get('color')
        });
      }
    }
  });

  $(function() {
    var colorControlsView, colorView, paletteView, tabView;
    colorView = new Panel.Views.ColorView({
      model: model
    });
    $('.side').html(colorView.render().el);
    paletteView = new Panel.Views.PaletteView({
      model: model
    });
    $('.middle').html(paletteView.render().el);
    colorControlsView = new Panel.Views.ColorControlsView({
      model: model
    });
    $('.middle').append(colorControlsView.render().el);
    tabView = new Panel.Views.TabView({
      model: model
    });
    tabView.on('selection', function(selection) {
      var view;
      view = (function() {
        switch (selection) {
          case 'schemas':
            return new Panel.Views.SchemaView({
              model: this.model
            });
          case 'blend':
            return new Panel.Views.BlendView({
              model: this.model
            });
          default:
            return new Panel.Views.RangeView({
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
