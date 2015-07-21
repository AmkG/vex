/*
component_col_base.vala - Define the ComponentColBase common
base type.

    Copyright 2015 Alan Manuel K. Gloria

    This file is part of VEX.

    VEX is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

*/

/*
The ComponentColBase is the actual implementation
base class for ComponentCol<T>.
*/

using Gee;

namespace VEX {

internal abstract
class ComponentColBase {
  internal abstract
  Type component_type();

  Component?[] components;

  /* Entity ID's start at 1 - entity 0 is
     an invalid entity.  In the below,
     we decrement the ID by 1 before using
     it to index.  */

  protected
  unowned Component?
  get_by_id(uint raw_id) {

    assert(raw_id != 0);

    var id = raw_id - 1;

    lock(components) {
      if (id < components.length) {
        return components[id];
      } else {
        return null;
      }
    }
  }

  protected
  unowned Component
  attach_by_id(uint raw_id) {

    assert(raw_id != 0);

    var id = raw_id - 1;

    lock(components) {
      /* Ensure sufficient size.  */
      if (id >= components.length) {
        components.resize((int) id + 1);
      }

      /* Construct if not existent.  */
      if (components[id] == null) {
        components[id] = (Component) Object.new (component_type ());
      }

      return (!) components[id];
    }
  }

  protected
  void
  detach_by_id (uint raw_id) {

    assert(raw_id != 0);

    var id = raw_id - 1;

    lock(components) {
      if (id >= components.length) return;
      components[id] = null;
    }
  }
}

}
