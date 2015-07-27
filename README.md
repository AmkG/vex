VEX Entity Component System Library for Vala
============================================

VEX is an entity/component system library written in
and for Vala.


Entity Component System
-----------------------

An Entity Component System is a structural pattern
commonly used in games or physics simulations.

Objects in the world are represented by "entities",
which may have characteristics or special effects
on the world.  Those characteristics are represented
by "components"; an "entity" may "attach" a "component",
which allocates some space for the data needed for
the special characteristic or effect.  The "component"
may then be "detached" from the "entity" if the entity
loses that characteristic or is destroyed.

A "system" is code that operates over all "entities"
in the world, often focused on updating or handling
one or a few "components" of each "entity", if the
"entity" has one attached.

One may visualize a world as being like a giant table,
with each "entity" being a row on the table, and each
"component" being a column.  A cell in the table may be
null or empty (i.e. the "component" is "detached" from
that particular "entity"); or, it may have a "component"
object (i.e. the "component" is "attached" to the
particular "entity").

The "systems" operating on the world are then the
routines that manipulate this table.


Entity Managers
---------------

Entity managers are the root of the VEX library.  They
handle the allocation of entities, and stores the table
that contains the components attached to each entity.

Entity managers are constructed simply:

    VEX.EntityManager manager = new VEX.EntityManager();

You may construct entities using the `create` method:

    VEX.Entity e = manager.create();

You may iterate over all live entities using `foreach`
on the manager:

    foreach (VEX.Entity e in manager) {
      // ...
    }


Entities
--------

Entities represent a numeric ID (of type uint).  The
ID can be used for whatever purpose it may serve.
In VEX, the ID is used as an index into arrays of
components (i.e. component columns).

Entities are managed by `EntityManager` objects.  Each
`EntityManager` has its own set of available and
allocated entity ID's.

In VEX, an `Entity` is an object, one of whose fields
is the `uint id`, the numeric ID of the `Entity`.
Each `Entity` instance represents an allocated ID.
Only when all references to that `Entity` are lost
will the ID be freed for reuse.

In VEX, entities serve as a bag of components.  An
entity may have 0 or 1 instances of a particular
component type.

You may query if a VEX Entity has a particular component
type using the `ref` method:

    MyComponent? mc = e.ref<MyComponent>();

If the entity does not have that component attached to it,
`ref` will return `null`.

You may attach a component type using the `attach`
method:

    MyComponent mc_attached = e.attach<MyComponent>();

If the entity already has the specified component
attached, then the `attach` method will return the
current component; it will only create a new component
if the entity does not currently have one.

You may detach a component type using the `detach`
method:

    e.detach<MyComponent>();

If the entity does not have that component attached,
then `detach` is a no-op.

You may destroy an entity using the `destroy` method:

    e.destroy();

Destroying an entity detaches all components attached
to that entity, and removes it from the list of live
entities in that manager.  The `Entity` object and its
ID, however, is not freed until all references to the
`Entity` (in a `Component` or in any other user
structure) are dropped.

You may determine if an entity is still alive or
already destroyed using the `is_live` method:

    if (e.is_live()) {
      // ...
    }


Components
----------

Components are defined by the user of the library.
Entity Component System best practice is that
components should contain little to no operational
code, just data or data-like objects.

Any component you define must derive from the
`Component` class.  `Component` is an implementation
type, so you cannot derive from another
implementation type:

    class MyComponent : VEX.Component {
      public Gee.ArrayList<uint?> list;

      construct {
        list = new Gee.ArrayList<uint?>();
      }

    }

Generally, you should use Vala's `construct` block
to initialize a component; VEX uses GObject
construction when attaching a component.

Since components are usually just data without
operational code, you should make all fields and
properties public.

VEX `Component` types derive from `GLib.Object`, so
you can use signals in components.

VEX `Component`s ensure that any `Entity` attached
to them are kept accessible.

You may define a destructor for your component class,
which will get called after the component is detached
from the entity.  However, the destructor may be
called some time after detachment, not immediately.


Component Columns
-----------------

In an Entity Component System, all data is organized
into a table where each row is an entity and each
column is a component type.

Often, entire pieces of code will be interested in
the data in one or a few columns.  To speed up access
to that data, VEX provides access to component
columns via the `ComponentCol<C>` generic type.

An `EntityManager` allows unowned access to
individual columns via the `get_component_col` method:

    unowned ComponentCol<MyComponent>
      my_component_col =
        manager.get_component_col<MyComponent>();

Component columns have `ref`, `attach`, and `detach`
methods, but take an `Entity` as an actual argument.

    MyComponent? mc = my_component_col.ref(entity);
    MyComponent mc_attached = my_component_col.attach(entity);
    my_component_col.detach(entity);

Referencing, attaching, and detaching has exactly the
same behavior as when using the methods on `Entity`.
However, if you are focused on just one or a few
columns, using component columns is slightly faster.

Finally, it's possible to iterate over the entities
attached to a component using `foreach`:

    foreach (Entity e in my_component_col) {
      // ...
    }

It is safe to detach the component while iterating
over its column; it is safe to detach the entity
being iterated or any entity, or even destroy the
entity or any entity:

    foreach (Entity e in my_component_col) {
      e.detach<MyComponent>();
      my_component_col.detach(e);
      e.destroy();
    }


Systems and Subsystems
----------------------

In the Entity Component System pattern, code is
organized into systems.  Each system is focused on
one or a few component types, and is written largely
indepedently of each other.

In VEX, a `System` is constructed by composing
several `Subsystem`-derived types.

All code that manipulates the entity component system
should be defined in classes derived from `Subsystem`:

    class Gravity : VEX.Subsystem {
      unowned VEX.ComponentCol<Velocity> vel_col;

      protected override
      void
      init() {
        vel_col = manager.get_component_col<Velocity>();
      }

      protected override
      void
      run() {
        foreach (Entity e in vel_col) {
          vel_col.ref(e).vy -= 9.8;
        }
      }
    }

    class Thrusters : VEX.Subsystem {
      unowned VEX.ComponentCol<Velocity> vel_col;
      unowned VEX.ComponentCol<Engine> engine_col;

      protected override
      void
      init() {
        vel_col = manager.get_component_col<Velocity>();
        engine_col = manager.get_component_col<Engine>();
      }

      protected override
      void
      run() {
        foreach (Entity e in engine_col) {
          var engine = engine_col.ref(e);
          if (engine.enabled) {
            vel_col.ref(e).vy += 15;
          }
        }
      }
    }

You can then compose a system by using the public, static
method `create_system`:

    void main() {

      var manager = new VEX.EntityManager();

      var system = VEX.create_system(manager)
        .begin()
          .run_<Gravity>()
          .run_<Thrusters>()
        .end()
        ;

      while (true) {
        system.run();
      }
    }

What the above code means is that, whenever the system's
`run` method is invoked, then first an instance of `Gravity`
is executed, then when it completes, an instance of
`Thrusters` is executed, then the system's `run` method
returns.

The object returned by `create_system` actually has two
variants of `run_` method:

      var system = VEX.create_system(manager)
        .begin()
          .run_<Gravity>()
          .run(new Thrusters())
        .end()
        ;

The `run_` method constructs the subsystem with a default
`GLib.Object.new` constructor, while the `run` method
accepts a subsystem as argument.  The latter method is
useful for systems that need access to external objects.


`Subsystem` Methods and Properties
----------------------------------

VEX `Subsystem` has a number of overridable methods and a
few utility methods and properties.

The read-only `manager` property is a reference to the
`EntityManager` that the constructed system will operate
on.  This property is not yet set at the `Subsystem`'s
`construct` block.

You may override the `init` method to do initialization.
The `manager` property has been set before the `init`
method is invoked, so any initialization of your
`Subsystem` that requires knowledge of the `EntityManager`
involved (such as acquiring component columns) should
be done in the `init` method:

    protected override
    void init() { /* ... */ }

You are required to override the abstract `run` method.
The `run` method is the core of your subsystem:

    protected override
    void run() { /* ... */ }

Finally, `Subsystem` provides a utility method, `subtask`,
which can be used to execute any `void`-returning method
that accepts no arguments.  This method can only be used
within your `run` method:

    protected override
    void run() {
      subtask(task1);
      subtask(task2);
    }
    void task1() { /* ... */ }
    void task2() { /* ... */ }

The `subtask` method uses a thread pool to run subtasks
in parallel.  The `run` method is not considered as having
returned until all `subtask`s that were initiated inside
it have completed.  This allows you to safely multithread
parts of your overall system while ensuring that a
`Subsystem` is completed before the next is initiated.


Multithreaded Systems
---------------------

In addition to just running your `Subsystem`s one after
another, a `System` can also run `Subsystem`s in parallel.

To do so, use `fork` and `join` on creating systems:

    System s = create_system(m)
      .begin()
        .fork()
           .run_<S1>()
           .run_<S2>()
        .join()
        .run_<S3>()
      .end()
      ;

The above means that `S1` and `S2` are executed in
parallel, then when they and all of their subtasks have
completed, `S3` is executed.

You may nest `fork`-`join` and `begin`-`end` to any
depth, but every `fork` must be closed by `join` and every
`begin` must be closed by `end`.

You are responsible for ensuring that `Subsystem`s executed
in parallel do not step on each other's toes; for example,
use mutexes or read-write locks.  As a general rule, if a
`Subsystem` writes to a component field that another
`Subsystem` reads or writes, you can't run them in parallel.

A possible exception might be component fields that are
operated on using commutative operations, such as a `velocity`
field that `Gravity` and `Thruster` subsystems just add or
subtract to; as long as access to the field is locked, you
can do them in parallel, then read the final velocity in
another subsystem in sequence to them.
