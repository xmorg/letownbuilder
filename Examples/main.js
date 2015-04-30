var canvas = CE.defines("canvas_id").
    ready(function() {
        canvas.Scene.call("letownbuilder");
    });
            
canvas.Scene.new({
    name: "letownbuilder",
    materials: {
        images: {
            img_id: "../data/icons/icon_001.png"
        }
    },
    preload: function() {
    
    },
    ready: function(stage) {
        this.element = this.createElement();
        this.element.drawImage("img_id");
        stage.append(this.element);
    },
    render: function(stage) {
        this.element.x += 1;
        stage.refresh();
    },
    exit: function(stage) {
    
    }
});
  
