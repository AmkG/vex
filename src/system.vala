/*
src/system.vala - Systems that operate on the entities
  of an EntityManager.

    Copyright 2015 Alan Manuel K. Gloria

    This file is part of VEX.

    VEX is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    VEX is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with VEX.  If not, see <http://www.gnu.org/licenses/>.

*/
namespace VEX {

public
class System : Object {
  EntityManager manager;
  Subsystem main;

  const int IDLE = 0;
  const int RUNNING = 1;
  const int FINISHED = 2;

  Mutex mtx = Mutex();
  Cond cnd = Cond();
  int state;

  internal
  System(owned EntityManager manager, owned Subsystem main) {
    this.manager = (owned) manager;
    this.main = (owned) main;
    this.state = IDLE;

    this.main.manager = this.manager;
    this.main.lib_init();
  }

  public
  void
  run() {
    launch();
    wait();
  }

  public
  void
  launch() {
    bool launch_flag = false;
    mtx.lock(); {
      if (state == IDLE) {
        state = RUNNING;
        launch_flag = true;
      }
    } mtx.unlock();

    if (launch_flag) {
      var last_seq_point = new SeqPoint(() => {
        mtx.lock(); {
          state = FINISHED;
        } mtx.unlock();
        cnd.broadcast();
      });
      VEX.TP.add(() => {
        main.lib_run((owned) last_seq_point);
      });
    }
  }
  public
  void
  wait() {
    mtx.lock(); {
      while (state == RUNNING) cnd.wait(mtx);
      state = IDLE;
    } mtx.unlock();
  }

  private
  void
  process1(owned SubsystemTaskWrapper wrapper) {
    var task = (owned) wrapper.task;
    wrapper = null;
    task();
  }
}

}
