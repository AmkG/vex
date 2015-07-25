/*
src/subsystem_seq.vala - A subsystem that
  executes other subsystems in sequence.

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

internal
class SubsystemSeq : Subsystem {
  Subsystem[] subsystems;

  public
  void
  add(Subsystem subsystem) {
    subsystems += subsystem;
  }

  protected override
  void pre_run() {
    foreach (var subsystem in subsystems) {
      subsystem.pre_run();
    }
  }
  protected override
  void
  run() {
    foreach (var subsystem in subsystems) {
      var sub_runner = new SubsystemRunner.with_parent_runner(runner);
      subsystem.runner = sub_runner;
      subsystem.run();
      sub_runner.wait_completion();
    }
  }
  protected override
  void post_run() {
    foreach (var subsystem in subsystems) {
      subsystem.runner = null;
      subsystem.post_run();
    }
  }
}

}
