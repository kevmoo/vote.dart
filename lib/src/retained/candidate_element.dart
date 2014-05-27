part of vote.retanied;

class CandidateElement extends Thing {
  final String _color;
  final MapPlayer player;
  final String _text;
  AffineTransform _tx;
  bool _hidden = false;

  CandidateElement(num w, num h, this._color, MapPlayer p) :
    player = p, _text = p.name, super(w, h) {
    _tx = addTransform();
  }

  bool get hidden => _hidden;

  void set hidden(bool value) {
    assert(value != null);
    if (value != _hidden) {
      _hidden = value;
      invalidateDraw();
    }
  }

  void drawOverride(CanvasRenderingContext2D ctx) {
    if (hidden) {
      ctx.globalAlpha = 0.3;
      ctx.fillStyle = '#999999';
    } else {

      final num shadowDistance = (Mouse.isMouseDirectlyOver(this)) ? 4 : 2;

      ctx.shadowColor = 'black';
      ctx.shadowBlur = 6;
      ctx.shadowOffsetX = shadowDistance;
      ctx.shadowOffsetY = shadowDistance;
      ctx.fillStyle = _color;
    }

    CanvasUtil.ellipse(ctx, 0, 0, this.width, this.height);
    ctx.fill();

    ctx.shadowColor = 'transparent';

    ctx.font = '1px Helvetica';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'baseline';
    ctx.fillStyle = 'black';
    ctx.fillText(_text, width * 0.5, height * 0.8);
  }
}
