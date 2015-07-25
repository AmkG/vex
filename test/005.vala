
using VEX;



class Odd : Component { }
class Even : Component { }

int processed = 0;

class OddSystem : Subsystem {
  unowned ComponentCol<Odd> odd_col;

  protected override
  void
  init() {
    odd_col = manager.get_component_col<Odd>();
  }

  protected override
  void
  run() {
    foreach (Entity e in odd_col) {
      AtomicInt.inc(ref processed);
      stdout.printf("OddSystem: Processing: %d\n", e.id);
      if (e.id % 2 == 0) {
        stdout.printf("OddSystem: Not odd!\n");
        Process.exit(1);
      }
    }
  }

}

class EvenSystem : Subsystem {
  unowned ComponentCol<Even> even_col;

  protected override
  void
  init() {
    even_col = manager.get_component_col<Even>();
  }
  protected override
  void
  run() {
    foreach (Entity e in even_col) {
      AtomicInt.inc(ref processed);
      stdout.printf("EvenSystem: Processing: %d\n", e.id);
      if (e.id % 2 != 0) {
        stdout.printf("EvenSystem: Not even!\n");
        Process.exit(1);
      }
    }
  }

}

const int NUMBER = 1000;

int
main() {

  var manager = new EntityManager();

  for (int i = 0; i < NUMBER; ++i) {
    Entity e = manager.create();
    if (e.id % 2 == 0) {
      e.attach<Even>();
    } else {
      e.attach<Odd>();
    }
  }

  System sboth = create_system(manager)
    .fork()
      .run_<OddSystem>()
      .run_<EvenSystem>()
    .join()
    ;
  stdout.printf("*** sboth.run().\n");
  processed = 0;
  sboth.run();
  stdout.printf("processed: %d\n", processed);
  if (processed != NUMBER) {
    stdout.printf( "** Expecting %d entities, but %d were processed\n"
                 , NUMBER, processed);
    return 1;
  }

  System sodd = create_system(manager)
    .run_<OddSystem>();
  stdout.printf("*** sodd.run().\n");
  processed = 0;
  sodd.run();
  stdout.printf("processed: %d\n", processed);
  if (processed != NUMBER / 2) {
    stdout.printf( "** Expecting %d entities, but %d were processed\n"
                 , NUMBER / 2, processed);
    return 1;
  }

  return 0;
}
