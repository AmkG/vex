/*
seq_point.vala - Define a sequence point, which, when finalized,
  puts a task on the static thread pool.

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
class SeqPoint {
  SubsystemTask task;
  internal
  SeqPoint(owned SubsystemTask task) {
    this.task = (owned) task;
  }

  ~SeqPoint() {
    VEX.TP.add((owned) task);
  }
}

}