class CandidateElement extends PElement {
  final String _color;
  final MapPlayer player;
  final String _text;
  core.AffineTransform _tx;

  CandidateElement(num w, num h, this._color, MapPlayer p) :
    player = p, _text = p.name, super(w, h) {
    _tx = addTransform();
  }

  void drawOverride(CanvasRenderingContext2D ctx){
    ctx.fillStyle = _color;
    CanvasUtil.ellipse(ctx, 0, 0, this.width, this.height);

    final num shadowDistance = Mouse.isMouseDirectlyOver(this) ?
        4 : 2;

    ctx.shadowColor = 'black';
    ctx.shadowBlur = 6;
    ctx.shadowOffsetX = shadowDistance;
    ctx.shadowOffsetY = shadowDistance;
    ctx.fill();

    ctx.shadowColor = 'transparent';

    ctx.font = '1px Helvetica';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'top';
    ctx.fillStyle = 'black';
    ctx.fillText(_text, width / 2, 0);
  }
}