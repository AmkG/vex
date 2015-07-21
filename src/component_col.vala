/*
entity.vala - Define the Entity type.

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
ComponentCol<T> represents one column of the EntityManager's
table.

Subsystems may query a ComponentCol<T> from their EntityManager
and then use it for Entities you iterate over.
*/

public
class ComponentCol<T> : ComponentColBase {
  internal override
  Type
  component_type() {
    return typeof(T);
  }

  internal
  ComponentCol(EntityManager manager) {
    base(manager);
  }

  public
  unowned T?
  get(Entity e) {
    assert (e.manager == manager);
    return (T) get_by_id (e.id);
  }
  public
  unowned T
  attach(Entity e) {
    assert (e.manager == manager);
    return (T) attach_by_id (e.id);
  }
  public
  void
  detach(Entity e) {
    assert (e.manager == manager);
    detach_by_id (e.id);
  }
}

}
