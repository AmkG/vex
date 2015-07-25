/*
entity.vala - Define the Entity and EntityAllocator types.

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

[Compact]
[CCode ( ref_function = "vex_entity_xref"
       , ref_function_void = true
       , unref_function = "vex_entity_unref")]
public
class Entity {
  /* Entity ID.  */
  public int id;
  /* The manager that manages this.  */
  internal unowned EntityManager manager;

  /* Refcount for this object.  */
  internal int _rc;
  /* The allocator that manages this.

     We use an owning pointer to EntityAllocator because
     the allocator must live longer than the Entities
     it manages.  */
  internal EntityAllocator _allocator;
  /* Used in the EntityAllocator to maintain the freelist.  */
  internal void* _next;

  /* Arrange so that the "normal" new Entity()
     expression calls Vex.EntityAllocator.alloc().  */
  [CCode (cname = "vex_entity_allocator_alloc")]
  internal extern Entity(EntityAllocator allocator);

  /* When the EntityAllocator's freelist is empty,
     use this constructor.  */
  internal
  Entity.make_fresh (int id, EntityAllocator allocator) {
    this.id = id;
    this._rc = 1;
    this._allocator = allocator;
    this._next = null;
  }

  /* Ref and unref functions.  */
  public
  void
  xref() {
    GLib.AtomicInt.add (ref _rc, 1);
  }
  public
  void
  unref() {
    if (GLib.AtomicInt.dec_and_test (ref _rc)) {
      _allocator.dealloc(this);
    }
  }

  /* When an EntityAllocator is destroyed,
     use this to free all entity memory.

     Vala automatically creates this function.  */
  internal
  extern void free();



  /* Client methods.  */

  public
  T?
  ref<T>() {
    return manager.get_component_col<T>().ref(this);
  }
  public
  T
  attach<T>() {
    return manager.get_component_col<T>().attach(this);
  }
  public
  void
  detach<T>() {
    manager.get_component_col<T>().detach(this);
  }

  public
  void
  destroy() {
    manager.destroy(this);
  }

  public
  bool
  is_live() {
    return manager.get_component_col<All>().ref(this) != null;
  }
}

internal
class EntityAllocator {
  /* The next free ID.  */
  int next_free;
  /* Entity objects that have been freed.  */
  void* freelist;

  internal
  EntityAllocator() {
    next_free = 0;
    freelist = null;
  }

  private
  int
  alloc_id () {
    int id = 0;
    int next = 0;
    do {
      id = GLib.AtomicInt.get(ref next_free);
      next = id + 1;
    } while (!GLib.AtomicInt.compare_and_exchange( ref next_free
                                                 , id
                                                 , next
                                                 )
            );
    return id;
  }

  internal
  Entity
  alloc() {
    /* Try to get from the freelist; if not, create fresh.  */
    void* cur = null;
    void* next = null;
    do {
      cur = GLib.AtomicPointer.get(&freelist);
      if (cur == null) {
        /* Freelist empty!  */
        return new Entity.make_fresh (alloc_id(), this);
      } else {
        next = ((Entity) cur)._next;
      }
    } while (!GLib.AtomicPointer.compare_and_exchange ( &freelist
                                                      , cur
                                                      , next
                                                      )
            );
    /* Reconnect the entity's allocator pointer to this.  */
    ((Entity) cur)._allocator = this;

    /* The return below should increment (correctly) the refcount.  */
    return (Entity) cur;
  }

  internal
  void
  dealloc (Entity e) {
    /* It's possible for the following to occur:

       1.  Someone decides to dispose the EntityManager holding
           this EntityAllocator.
       2.  Somebody else is still looking at some Entity, which
           keeps this EntityAllocator alive.
       3.  That someone else disposes the Entity it was working
           on.

       This may cause this EntityAllocator to be freed during
       execution of this method.  To prevent that, we
       keep the self variable around during the method call.  */
    EntityAllocator self = this;

    /* Detach the entity->allocator pointer.  */
    e._allocator = null;

    void *cur = null;
    void *next = (void*) e;
    do {
      cur = GLib.AtomicPointer.get(&self.freelist);
      e._next = cur;
    } while (!GLib.AtomicPointer.compare_and_exchange (&self.freelist
                                                      , cur
                                                      , next
                                                      )
            );
  }

  ~EntityAllocator() {
    while (freelist != null) {
      unowned Entity e = (Entity) freelist;
      freelist = e._next;
      e.free();
    }
  }
}

}
