// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ci_dangerzone_app/race_track.dart';
import 'package:lua_dardo/lua.dart';

class ScriptHandler {
  final state = LuaState.newState();
  final RaceTrack track;
  final String script;

  final _rnd = Random(DateTime.now().millisecondsSinceEpoch);

  ScriptHandler({required this.track, required this.script});

  int _makeObstacle(LuaState ls) {
    final x = ls.checkNumber(1);
    final y = ls.checkNumber(2);
    ls.checkType(3, LuaType.luaBoolean);
    final visible = ls.toBoolean(3);

    // now we have them, pop args off the Lua stack
    ls.pop(3);

    print("FROM LUA: $x, $y, $visible");

    if (x == null || y == null) {
      throw ArgumentError("x and y cannot be null");
    }

    track.addObstacle(x, y, visible);

    return 1;
  }

  int _randomNumber(LuaState ls) {
    final n = _rnd.nextDouble();
    ls.pushNumber(n);
    return 1;
  }

  int _printFromLua(LuaState ls) {
    final mesg = ls.checkString(1);
    // now we have them, pop args off the Lua stack
    ls.pop(1);
    print("[LUA] $mesg");
    return 1;
  }

  void createObstacles() {
    state.loadString(script);
    print("Lua:\n $script");
    // eval the Lua chunk before we can call functions in it
    state.call(0, 0);

    state.register("mkObstacle", _makeObstacle);
    state.register("print", _printFromLua);
    state.register("random", _randomNumber);

    const funcName = "doObstacles";
    // now get the Lua script function
    final t = state.getGlobal(funcName);

    // check we found the Lua function we expected
    if (t != LuaType.luaFunction) {
      print("type err, expected a function but got [$t] ${state.toStr(-1)}");
      return;
    }

    // and now run the Lua function
    final r = state.pCall(0, 0, 1);
    if (r != ThreadStatus.lua_ok) {
      print("Lua error calling $funcName: ${state.toStr(-1)}");
      return;
    }
  }
}
