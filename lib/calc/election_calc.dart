class ElectionCalc {
  SendPort _sendPort;

  ElectionCalc() {
    _sendPort = spawnFunction(_electionCalcIsolate);
  }

  Future<Dynamic> doCalc(Dynamic message) {
    return _sendPort.call(message);
  }

}

void _electionCalcIsolate() {
  print('hello from isolate!');
  port.receive((msg, reply) {
    print("I received: $msg");
    reply.send(msg);
  });
}
