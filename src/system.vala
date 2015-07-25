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
  Subsystem main;

  ThreadPool<SubsystemTaskWrapper> tp;

  internal
  System(Subsystem main) {
    this.main = main;
    try {
      tp = new ThreadPool<SubsystemTaskWrapper>.with_owned_data
        ( /*func*/        process1
        , /*max_threads*/ (int) get_num_processors()
        , /*exclusive*/   false
        );
    } catch (ThreadError ignored) { }
  }

  public
  void
  run() {
    main.lib_pre_run();

    SubsystemRunner runner = new SubsystemRunner(tp);
    main.runner = runner;
    main.lib_run();
    runner.wait_completion();
    main.runner = null;
    runner = null;

    main.lib_post_run();
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
