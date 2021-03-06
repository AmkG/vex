/*
src/subsystem.vala - A code container that may be
  composed to form entire Systems.

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

/*
Subsystem derivatives must be default-constructible using
Object.new().

This generally means any complex construction must be done
in a construct { } block.

*/

/*

Multithreaded systems:

While building a multithreaded system out of subsystems,
be aware of the following:

1.  If you run two subsystems A and B in parallel where
    A detaches components that B is reading, then
    B may acquire the component via a ref<>, then A
    detaches it, then B will continue (the component
    will still be live, but may contain stale state).
    You should handle this possibility yourself.

2.  Obviously if you have multiple parallel subsystems
    where one or more perform writes to components,
    you should handle this yourself.
    
*/

public abstract
class Subsystem : Object {
  /* Provide access to the manager of this
     subsystem.

     This property is not yet valid in the construct
     block; if you need access to the manager
     while doing some initialization, override the
     init() virtual method.  */
  public
  unowned EntityManager? manager { public get; internal set; }

  internal SeqPoint? next_seq_point;

  /* Launches a subtask in parallel with the subsystem's
     run method.  The system containing this subsystem
     will wait for all subtasks of this subsystem to
     complete before considering the subsystem to be
     finished.

     Should only be used inside the run() method of
     a subsystem.  */
  protected
  void
  subtask (owned SubsystemTask task) {
    assert(next_seq_point != null);
    var my_seq_point = next_seq_point;
    VEX.TP.add(() => {
      try {
        task();
      } finally {
        my_seq_point = null;
      }
    });
  }

  protected virtual
  void init() { }

  protected abstract
  void run();

  internal inline
  void
  lib_init() { this.init(); }

  internal inline
  void
  lib_run(owned SeqPoint seq_point) {
    next_seq_point = (owned) seq_point;
    try {
      this.run();
    } finally {
      next_seq_point = null;
    }
  }
}

}
