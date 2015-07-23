/*
component.vala - Define the Component base class.

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

public abstract
class Component : Object {
  Entity? _entity = null;

  internal
  void
  set_entity(Entity entity) {
    lock (this._entity) { this._entity = entity; }
  }
  internal
  Entity?
  get_entity() {
    lock (this._entity) { return this._entity; }
  }
}

}
