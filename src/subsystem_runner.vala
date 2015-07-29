/*
src/subsystem_runner.vala - A class handling subsystem
  subtask completion.

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

public delegate
void SubsystemTask();

/* Delegates can't be generic types.  Use the
   wrapper class below instead.  */
[Compact]
internal
class SubsystemTaskWrapper {
  public SubsystemTask task;
  public
  SubsystemTaskWrapper(owned SubsystemTask task) {
    this.task = (owned) task;
  }
}

[Compact]
internal
class SubsystemRunner {
  public Mutex mtx = Mutex();
  public Cond cond = Cond();
  public int rc = 0;

  internal
  SubsystemRunner() {
  }

  internal
  void
  wait_completion() {
    mtx.lock();
    while (rc != 0) {
      cond.wait(mtx);
    }
    mtx.unlock();
  }
  internal
  void
  run(owned SubsystemTask task) {
    exec_run(this, (owned) task);
  }
  internal static
  void
  exec_run (SubsystemRunner runner, owned SubsystemTask task) {
    runner.countup();
    VEX.TP.add(() => {
      try {
        task();
      } finally {
        runner.countdown();
      }
    });
  }
  private
  void
  countup() {
    mtx.lock();
    ++rc;
    mtx.unlock();
  }
  private
  void
  countdown() {
    mtx.lock();
    --rc;
    if (rc == 0) {
      cond.broadcast();
    }
    mtx.unlock();
  }
}

}
