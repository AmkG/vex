/*
src/component_col_iterator.vala - Iterator that traverses
  a component column.

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
struct ComponentColIterator {
  Component? c;
  RWLock* rwl;

  public
  Entity?
  next_value() {
    if (c == null) {
      return null;
    }

    Entity? rv = null;

    rwl->reader_lock(); {
      /* Skip over detached components.  */
      while (c != null && c.entity == null) {
        c = c.next;
      }
      /* Get the current value and move forward.  */
      if (c != null) {
        rv = c.entity;
        c = c.next;
      }
    } rwl->reader_unlock();
    return rv;
  }
}

}
