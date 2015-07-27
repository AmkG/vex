/*
system_factory.vala - Procedures to construct a
  System from Subsystems.

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

/* Public interface to constructing a system.

Usage:

System sys = create_system(manager)
  .begin()
    .run(subsystem_to_run_first)
    .run_<SubSystemToRunSecond>()
    .fork()
      .run(subsystem_to_run_third_in_parallel)
      .run_<SubSystemToRunThirdInParallel2>()
    .join()
  .end()
  ;

// For very simple systems containing just one subsystem.
System sys = create_system(manager)
  .run(subsystem);

*/
public
SystemFactoryTop
create_system(owned EntityManager m) {
  return new SystemFactoryTop((owned) m);
}

[Compact]
public
class SystemFactoryTop {
  internal EntityManager m;

  public
  SystemFactoryTop(owned EntityManager m) {
    this.m = (owned) m;
  }

  public
  System
  run (owned Subsystem s) {
    return new System((owned) m, (owned) s);
  }
  public
  System
  run_<T> () {
    return run ((Subsystem) Object.new(typeof(T)));
  }

  public
  SystemFactorySeq<System>
  begin() {
    return new SystemFactorySeq<System>(run);
  }
  public
  SystemFactoryPar<System>
  fork() {
    return new SystemFactoryPar<System>(run);
  }
}

internal
delegate
Parent ParentifyFunc<Parent>(owned Subsystem s);

public
class SystemFactorySeq<Parent> {
  SubsystemSeq seq;

  ParentifyFunc<Parent> parentify;

  internal
  SystemFactorySeq(owned ParentifyFunc<Parent> parentify) {
    this.parentify = (owned) parentify;
    this.seq = new SubsystemSeq();
  }

  public
  unowned SystemFactorySeq<Parent>
  run(owned Subsystem s) {
    seq.add((owned) s);
    return this;
  }

  public
  unowned SystemFactorySeq<Parent>
  run_<T>() {
    return run((Subsystem) Object.new(typeof(T)));
  }

  public
  Parent
  end() {
    return parentify((owned) seq);
  }

  public
  SystemFactorySeq< SystemFactorySeq<Parent> >
  begin() {
    return new SystemFactorySeq< SystemFactorySeq<Parent> >
      ( add_and_return_me );
  }
  public
  SystemFactoryPar< SystemFactorySeq<Parent> >
  fork() {
    return new SystemFactoryPar< SystemFactorySeq<Parent> >
      ( add_and_return_me );
  }

  private
  SystemFactorySeq<Parent>
  add_and_return_me(owned Subsystem s) {
    seq.add(s);
    return this;
  }
}

public
class SystemFactoryPar<Parent> {
  SubsystemPar par;

  ParentifyFunc<Parent> parentify;

  internal
  SystemFactoryPar(owned ParentifyFunc<Parent> parentify) {
    this.parentify = (owned) parentify;
    this.par = new SubsystemPar();
  }

  public
  unowned SystemFactoryPar<Parent>
  run(owned Subsystem s) {
    par.add((owned) s);
    return this;
  }
  public
  unowned SystemFactoryPar<Parent>
  run_<T>() {
    return run((Subsystem) Object.new(typeof(T)));
  }

  public
  Parent
  join() {
    return parentify((owned) par);
  }

  public
  SystemFactorySeq< SystemFactoryPar<Parent> >
  begin() {
    return new SystemFactorySeq< SystemFactoryPar<Parent> >
      ( add_and_return_me );
  }
  public
  SystemFactoryPar< SystemFactoryPar<Parent> >
  fork() {
    return new SystemFactoryPar< SystemFactoryPar<Parent> >
      ( add_and_return_me );
  }

  private
  SystemFactoryPar<Parent>
  add_and_return_me(owned Subsystem s) {
    par.add(s);
    return this;
  }
}

/*
internal
System
example(EntityManager m, Subsystem s) {
  return create_system (m)
    .begin()
      .fork()
        .begin()
          .run(s)
          .run(s)
        .end()
        .run(s)
      .join()
      .run(s)
      .fork()
        .run(s)
        .run(s)
      .join()
    .end()
    ;
}
*/

}
