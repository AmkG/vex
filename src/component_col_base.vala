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

  internal
  unowned EntityManager manager;

  internal ComponentColBase(EntityManager manager) {
    this.manager = manager;
  }

  Component?[] components;

  internal
  unowned Component?
  get_by_id(uint id) {
    lock(components) {
      if (id < components.length) {
        return components[id];
      } else {
        return null;
      }
    }
  }

  internal
  unowned Component
  attach_by_id(uint id, Entity e) {
    lock(components) {
      /* Ensure sufficient size.  */
      if (id >= components.length) {
        components.resize((int) id + 1);
      }

      /* Construct if not existent.  */
      if (components[id] == null) {
        components[id] = (Component) Object.new (component_type ());
        components[id].set_entity(e);
      }

      return (!) components[id];
    }
  }

  internal
  void
  detach_by_id (uint id) {
    lock(components) {
      if (id >= components.length) return;
      components[id] = null;
    }
  }
}

}
