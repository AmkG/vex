
using VEX;

class Odd : Component { }
class Even : Component { }

const int NUMBER = 42;

int
main() {

  var m = new EntityManager();

  for (var i = 0; i < NUMBER; ++i) {
    var e = m.create();
    if (e.id % 2 == 0) {
      e.attach<Even>();
    } else {
      e.attach<Odd>();
    }
  }

  int count = 0;

  stdout.printf("Even entities:");
  foreach (Entity e in m.get_component_col<Even>()) {
    stdout.printf(" %d", e.id);
    if (e.id % 2 != 0) {
      stdout.printf(" ** Not an even number! **\n");
      return 1;
    }
    ++count;
  }
  stdout.printf("\n");
  stdout.printf("Odd entities:");
  foreach (Entity e in m.get_component_col<Odd>()) {
    stdout.printf(" %d", e.id);
    if (e.id % 2 == 0) {
      stdout.printf(" ** Not an odd number! **\n");
      return 1;
    }
    ++count;
  }
  stdout.printf("\n");

  if (count != NUMBER) {
    stdout.printf("Oops, missing entity!\n");
    return 1;
  }

  stdout.printf("OK\n");
  return 0;
}
