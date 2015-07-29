/*
thread_pool.vala - Define a singleton thread pool for all
  VEX Systems to use.

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

namespace VEX.TP {

private static
Once< ThreadPool<SubsystemTaskWrapper> > singleton;

private static
unowned ThreadPool<SubsystemTaskWrapper>
get() {
  return singleton.once(() => {

    ThreadPool<SubsystemTaskWrapper>? rv = null;

    try {
      rv = new ThreadPool<SubsystemTaskWrapper>.with_owned_data
        ( /*func*/          process1
        , /*max_threads*/   (int) get_num_processors()
        , /*exclusive*/     false
        );
    } catch (ThreadError ignored) { }

    return (!) (owned) rv;

  });
}

private static
void
process1 (owned SubsystemTaskWrapper wrapper) {
  var task = (owned) wrapper.task;
  wrapper = null;
  task();
}

/* Library access.  */
internal static
void
add(owned SubsystemTask task) {
  try {
    get().add(new SubsystemTaskWrapper((owned) task));
  } catch (ThreadError ignored) { }
}

}
