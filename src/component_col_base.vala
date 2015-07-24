/*
component_col_base.vala - Define the ComponentColBase common
base type.

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

/*
The ComponentColBase is the actual implementation
base class for ComponentCol<T>.
*/

using Gee;

namespace VEX {

public abstract
class ComponentColBase {
  internal abstract
  Type component_type();

  RWLock rwl;

  internal
  unowned EntityManager manager;

  internal ComponentColBase(EntityManager manager) {
    this.manager = manager;
  }

  Component?[] components;
  Component? list;

  internal
  Component?
  ref_by_id(uint id) {
    Component? rv;

    rwl.reader_lock(); {
      if (id < components.length) {
        rv = components[id];
      } else {
        rv = null;
      }
    } rwl.reader_unlock();

    return rv;
  }

  internal
  Component
  attach_by_id(uint id, owned Entity e) {
    Component? rv = null;

    rwl.writer_lock(); try {
      /* Ensure sufficient size.  */
      if (id >= components.length) {
        components.resize((int) id + 1);
      }

      /* Construct if not existent.  */
      if (components[id] == null) {
        Component c = (Component) Object.new (component_type ());
        c.entity = (owned) e;
        c.prev = null;

        list.prev = c;
        c.next = (owned) list;
        list = c;

        components[id] = (owned) c;
      }

      rv = components[id];

    } finally {
      rwl.writer_unlock();
    }
    return (!) rv;
  }

  internal
  void
  detach_by_id (uint id) {
    rwl.writer_lock(); try {
      /* If ID is within the components length,
         check for detachability.  */
      if (id < components.length) {
        /* Detach.  */
        Component? c = (owned) components[id];

        /* Unlink the node in the list.  */
        if (c != null) {
          if (c.prev == null) {
            list = c.next;
          } else {
            c.prev.next = c.next;
          }
          if (c.next != null) {
            c.next.prev = c.prev;
          }

          /* Clear out the component.  */
          c.entity = null;
          c.prev = null;
          /* Retain next, in case a live iterator has this component.  */
        }
      }
    } finally {
      rwl.writer_unlock();
    }
  }

  /* Allow iteration over a component column.  */

  public
  ComponentColIterator
  iterator() {
    ComponentColIterator rv = ComponentColIterator();
    rv.rwl = &rwl;

    rwl.reader_lock(); {
      rv.c = list;
    } rwl.reader_unlock();

    return rv;
  }
}

}
