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

namespace VEX{

public struct Entity {
  unowned EntityManager manager;
  uint id;

  /* Access components of entity.  */
  public
  unowned T?
  get<T>() {
    return manager.get_component_col<T>().get(this);
  }
  public
  unowned T
  attach<T>() {
    return manager.get_component_col<T>().attach(this);
  }
  public
  void
  detach<T>() {
    manager.get_component_col<T>().detach(this);
  }

  /* Destroy entity.  */
  public
  void
  destroy() {
    manager.destroy(this);
  }
}

}
