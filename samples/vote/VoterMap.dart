class VoterMap extends PElement {
  static final num _count = 10;

  VoterMap(int w, int h):super(w, h);


  void drawOverride(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'red';
    var w = width / _count;
    var h = height / _count;
    var margin = 3;

    for(var x = 0; x < _count; x++){
      for(var y = 0; y < _count; y++){
        CanvasUtil.ellipse(ctx, x * w + margin, y * h + margin, w - 2 * margin, h - 2 * margin);
        ctx.fill();
      }
    }

  }
}
