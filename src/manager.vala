/*
manager.vala - Define the EntityManager type.

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

using Gee;

namespace VEX {

/*
The EntityManager is the core of an Entity Component System.
It represents a table, where each row is an entity, and
each column a component.  Each cell of the table may be
either null, or a component.
*/

public class EntityManager {
  public EntityManager() {
    next_free = 1;
    free_list = new ArrayList<uint>();
  }

  /* The free entity list.  Entity 0 is not valid.  */
  uint next_free;
  ArrayList<uint> free_list;

  /* The entity table.  */
  HashMap<Type, ComponentColBase> columns;

  /* Get access to a component column.  Normally, getting
     an entity's component is a two-step process: get
     component column, then look up an entity in the
     column.  However, if a client is interested in
     looking up multiple entities along a single column,
     it can amortize the cost of the first lookup by
     acquiring the column with get_component_col, then
     doing entity lookups using the component column.  */
  public
  unowned ComponentCol<T>
  get_component_col<T> () {
    var t = typeof(T);
    lock (columns) {
      if (!columns.has_key (t)) {
        columns[t] = new ComponentCol<T>(this);
      }
      var rv = columns[t];
      return (ComponentCol<T>) rv;
    }
  }

  /* Allocate a new entity.  */
  public
  Entity
  create () {
    /* First, get from free list.  */
    uint rv;
    lock (free_list) {
      if (free_list.size == 0) {
        rv = next_free;
        ++next_free;
      } else {
        rv = free_list.remove_at(free_list.size - 1);
      }
    }
 
    Entity e = Entity()
      { manager = this
      , id = rv
      };

    /* Now attach All component.  */
    get_component_col<All>().attach(e);

    return e;
  }

  /* Destroy an existing entity.  */
  public
  void
  destroy (Entity e) {
    assert (e.manager == this);

    var id = e.id;

    /* Detach all components.  */
    var columns_copy = new ArrayList<ComponentColBase>();
    lock (columns) {
      columns_copy.add_all(columns.values);
    }
    foreach (ComponentColBase col in columns_copy) {
      col.detach_by_id(id);
    }

    /* Add to freelist.  */
    lock (free_list) {
      free_list.add (id);
    }

    /* Clear out the entity.  */
    e.manager = null;
    e.id = 0;
  }
}

/* Component that represents All entities.  */
public class All : Component { }

}
